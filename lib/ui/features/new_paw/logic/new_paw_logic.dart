import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rescupaws/data/enums/new_paw_enums.dart';
import 'package:rescupaws/data/network/location/location_repository.dart';
import 'package:rescupaws/data/network/paw_entry/paw_entry_repository.dart';
import 'package:rescupaws/data/network/user/user_repository.dart';
import 'package:rescupaws/data/services/supabase_image_service.dart';
import 'package:rescupaws/models/categories_response.dart';
import 'package:rescupaws/models/location_response.dart';
import 'package:rescupaws/models/new_paw_model.dart';
import 'package:rescupaws/models/paw_entry.dart';
import 'package:rescupaws/models/vaccine_info.dart';
import 'package:rescupaws/ui/features/category/data/category_repository.dart';
import 'package:rescupaws/ui/features/new_paw/model/new_paw_ui_model.dart';
import 'package:rescupaws/utils/riverpod_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_paw_logic.g.dart';

@riverpod
Future<List<Category>> fetchCategories(Ref ref) async {
  /// OLMMM BU COK GUZEL BIR SEY
  ref.keepAlive();
  CategoryRepository categoryRepository =
      ref.watch(getCategoryRepositoryProvider);
  GetCategoriesResponse categories =
      await categoryRepository.getCategories();
  return categories.data;
}

@riverpod
Future<List<Category>> fetchSubCategories(
    Ref ref, String categoryId) async {
  ref.keepAlive();
  CategoryRepository categoryRepository =
      ref.watch(getCategoryRepositoryProvider);
  GetCategoriesResponse categories =
      await categoryRepository.getSubCategories(categoryId);
  return categories.data;
}

@riverpod
Future<NewPawResponse> createPawEntry(
    Ref ref, PawEntry pawEntry, List<AssetEntity> imageAssets) async {
  if (pawEntry.name == null) {
    Logger().e('paw entry name is null');
    throw Exception('İlan adı boş olamaz');
  }
  
  // Validate that at least one image is provided
  if (imageAssets.isEmpty) {
    Logger().e('paw entry has no images');
    throw Exception('En az bir fotoğraf eklemelisiniz');
  }
  
  // Validate maximum 5 images
  if (imageAssets.length > 5) {
    Logger().e('paw entry has too many images: ${imageAssets.length}');
    throw Exception('En fazla 5 fotoğraf ekleyebilirsiniz');
  }
  
  Logger().i('Uploading images to Supabase...');
  
  // Get Supabase image service
  SupabaseImageService imageService = ref.read(supabaseImageServiceProvider);
  
  // Convert AssetEntities to bytes and upload to Supabase
  List<Uint8List> imageBytesList = <Uint8List>[];
  for (AssetEntity asset in imageAssets) {
    // Use thumbnail with quality setting for better performance
    Uint8List? bytes = await asset.thumbnailDataWithSize(
      const ThumbnailSize(1920, 1920),
      quality: 85,
    );
    
    if (bytes != null) {
      imageBytesList.add(bytes);
    } else {
      // Fallback to origin bytes if thumbnail fails
      Uint8List? originBytes = await asset.originBytes;
      if (originBytes != null) {
        imageBytesList.add(originBytes);
      }
    }
  }
  
  // Upload images to Supabase and get URLs
  List<String> imageUrls = await imageService.uploadImages(
    imageBytesList: imageBytesList,
    userId: pawEntry.user_id ?? 'unknown',
    baseFileName: 'paw_${pawEntry.id}',
  );
  
  Logger().i('Images uploaded successfully. URLs: $imageUrls');
  
  // Update paw entry with image URLs
  PawEntry updatedPawEntry = pawEntry.copyWith(image: imageUrls);
  
  Logger().i('Creating paw entry in Firestore...');
  PawEntryRepository pawEntryRepository =
      ref.read(getPawEntryRepositoryProvider);
  // Ensure the current user exists in 'users' so advertiser_ref resolves
  await ref.read(getUserRepositoryProvider).upsertCurrentUser();
  NewPawResponse response =
      await pawEntryRepository.createPawEntry(updatedPawEntry);
  Logger().i('Paw entry created successfully');
  return response;
}

// Provider for Supabase image service
@riverpod
SupabaseImageService supabaseImageService(Ref ref) {
  return SupabaseImageService(Logger());
}

@riverpod
Future<PermissionState> fetchPermissionState(
    Ref ref) async {
  ref.keepAlive();
  PermissionState ps = await PhotoManager.requestPermissionExtend();
  debugPrint('permission state: $ps');
  return ps;
}

@riverpod
Future<List<AssetEntity>> fetchImages(Ref ref) async {
  ref.cacheFor(const Duration(minutes: 10));
  List<AssetEntity> assets = await PhotoManager.getAssetListRange(
    start: 0,
    end: 20,
    type: RequestType.image,
    filterOption: FilterOptionGroup(
        // createTimeCond: DateTimeCond(
        //   min: DateTime.now().subtract(const Duration(days: 2)),
        //   max: DateTime.now(),
        // ),
        ),
  );
  return assets;
}

@Riverpod(keepAlive: true)
class NewPawLogic extends _$NewPawLogic {
  @override
  NewPawUiModel build() {
    return NewPawUiModel(
      user_id: FirebaseAuth.instance.currentUser!.uid,
    );
  }

  void setPawName(String name) {
    state = state.copyWith(name: name);
  }

  void setPawDescription(String description) {
    state = state.copyWith(description: description);
  }

  void setPawAge(String age) {
    state = state.copyWith(age: age);
  }

  void togglePawVaccine(Vaccines vaccines) {
    switch (vaccines) {
      case Vaccines.RABIES:
        state = state.copyWith(rabies_vaccine: !state.rabies_vaccine);
      case Vaccines.DISTEMPER:
        state = state.copyWith(distemper_vaccine: !state.distemper_vaccine);
      case Vaccines.HEPATITIS:
        state = state.copyWith(hepatitis_vaccine: !state.hepatitis_vaccine);
      case Vaccines.PARVOVIRUS:
        state = state.copyWith(parvovirus_vaccine: !state.parvovirus_vaccine);
      case Vaccines.BORDETELLA:
        state = state.copyWith(bordotella_vaccine: !state.bordotella_vaccine);
      case Vaccines.LEPTOSPIROSIS:
        state =
            state.copyWith(leptospirosis_vaccine: !state.leptospirosis_vaccine);
      case Vaccines.PANLEUKOPENIA:
        state =
            state.copyWith(panleukopenia_vaccine: !state.panleukopenia_vaccine);
      case Vaccines.HERPESVIRUSandCALICIVIRUS:
        state = state.copyWith(
            herpesvirus_and_calicivirus_vaccine:
                !state.herpesvirus_and_calicivirus_vaccine);
    }
  }

  void setPawWeight(num weight) {
    state = state.copyWith(weight: weight);
  }

  void setWeightMeasure() {
    bool isKg = !state.isKg;
    num weight = state.weight ?? 0;
    if (isKg) {
      weight = weight / 2.20462;
    } else {
      weight = weight * 2.20462;
    }
    state = state.copyWith(isKg: isKg, weight: weight);
  }

  void setPawGender(int gender) {
    state = state.copyWith(gender: gender);
  }

  void setPawEducationLevel(int educationLevel) {
    state = state.copyWith(education: educationLevel);
  }

  void setError(String error) {
    state = state.copyWith(error: error);
  }

  void setLoading({bool isLoading = false}) {
    state = state.copyWith(isImageLoading: isLoading);
  }

  void setImages(List<AssetEntity> images) {
    state = state.copyWith(assets: images);
  }

  /// Adds an [AssetEntity] or a list of [AssetEntity]s to the [assets] list.
  /// Images will be uploaded to Supabase when creating the paw entry.
  Future<void> addAssets({required List<AssetEntity> assets}) async {
    if (assets.isEmpty) return;
    setLoading(isLoading: true);
    List<AssetEntity> images =
        List<AssetEntity>.from(state.assets ?? <AssetEntity>[]);
    
    // Add new assets to the list
    images.addAll(assets);
    
    // Update state with new assets
    // No need to encode to base64 anymore - we upload directly to Supabase
    state = state.copyWith(
        assets: images, isImageLoading: false);
    return Future<void>.value();
  }

  /// Adds a file to the asset manager and returns the corresponding [AssetEntity].
  /// If the [file] is null, returns null.
  /// Uses the [PhotoManager.editor.saveImageWithPath] method to save the image with the given [file.path].
  /// The saved image is titled 'paw'.
  /// After adding the image to the asset manager, it is also added to the list of images.
  /// Returns the added [AssetEntity].
  Future<AssetEntity?> addFile(File? file) async {
    if (file == null) {
      return null;
    }
    AssetEntity asset = await PhotoManager.editor.saveImageWithPath(
      file.path,
      title: 'paw',
    );
    addImage(asset);
    return asset;
  }

  /// Adds an [AssetEntity] to the list of images in the state.
  ///
  /// If the [image] already exists in the list, it is removed.
  /// Otherwise, it is added to the list and the carousel controller moves to the next page.
  /// Finally, the state is updated with the new list of assets.
  void addImage(AssetEntity image) {
    List<AssetEntity> images =
        List<AssetEntity>.from(state.assets ?? <AssetEntity>[]);
    if (images.contains(image)) {
      images.remove(image);
    } else {
      images.add(image);
    }
    state = state.copyWith(assets: images);
  }

  void setCategoryId(String categoryId) {
    state = state.copyWith(category_id: categoryId);
  }

  void setSubCategoryId(String subCategoryId) {
    state = state.copyWith(sub_category_id: subCategoryId);
  }

  void setCountry(Country? country) {
    state = state.copyWith(country: country);
  }

   Future<GetLocationsResponse> setCity(City city) {
    state = state.copyWith(city: city);
    LocationRepository locationRepository =
        ref.read(getLocationRepositoryProvider);
    return locationRepository.getDistricts(cityId: city.id);
  }

  void setDistrict(District? district) {
    state = state.copyWith(district: district);
  }

  void setAddress(String? address) {
    state = state.copyWith(address: address);
  }
}
