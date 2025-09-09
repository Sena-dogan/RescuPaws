import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/enums/new_paw_enums.dart';
import '../../../../data/network/location/location_repository.dart';
import '../../../../data/network/paw_entry/paw_entry_repository.dart';
import '../../../../models/categories_response.dart';
import '../../../../models/location_response.dart';
import '../../../../models/new_paw_model.dart';
import '../../../../utils/riverpod_extensions.dart';
import '../../category/data/category_repository.dart';
import '../model/new_paw_ui_model.dart';

part 'new_paw_logic.g.dart';

@riverpod
Future<List<Category>> fetchCategories(Ref ref) async {
  /// OLMMM BU COK GUZEL BIR SEY
  ref.keepAlive();
  final CategoryRepository categoryRepository =
      ref.watch(getCategoryRepositoryProvider);
  final GetCategoriesResponse categories =
      await categoryRepository.getCategories();
  return categories.data;
}

@riverpod
Future<List<Category>> fetchSubCategories(
    Ref ref, String categoryId) async {
  ref.keepAlive();
  final CategoryRepository categoryRepository =
      ref.watch(getCategoryRepositoryProvider);
  final GetCategoriesResponse categories =
      await categoryRepository.getSubCategories(categoryId);
  return categories.data;
}

@riverpod
Future<NewPawResponse> createPawEntry(
    Ref ref, NewPawModel newPawModel) async {
  if (newPawModel.name == null) {
    Logger().e('new paw model name is null');
    throw Exception('new paw model name is null');
  }
  Logger().i('new paw model: $newPawModel');
  final PawEntryRepository pawEntryRepository =
      ref.read(getPawEntryRepositoryProvider);
  final NewPawResponse pawEntry =
      await pawEntryRepository.createPawEntry(newPawModel);
  return pawEntry;
}

@riverpod
Future<PermissionState> fetchPermissionState(
    Ref ref) async {
  ref.keepAlive();
  final PermissionState ps = await PhotoManager.requestPermissionExtend();
  debugPrint('permission state: $ps');
  return ps;
}

@riverpod
Future<List<AssetEntity>> fetchImages(Ref ref) async {
  ref.cacheFor(const Duration(minutes: 10));
  final List<AssetEntity> assets = await PhotoManager.getAssetListRange(
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
        break;
      case Vaccines.DISTEMPER:
        state = state.copyWith(distemper_vaccine: !state.distemper_vaccine);
        break;
      case Vaccines.HEPATITIS:
        state = state.copyWith(hepatitis_vaccine: !state.hepatitis_vaccine);
        break;
      case Vaccines.PARVOVIRUS:
        state = state.copyWith(parvovirus_vaccine: !state.parvovirus_vaccine);
        break;
      case Vaccines.BORDETELLA:
        state = state.copyWith(bordotella_vaccine: !state.bordotella_vaccine);
        break;
      case Vaccines.LEPTOSPIROSIS:
        state =
            state.copyWith(leptospirosis_vaccine: !state.leptospirosis_vaccine);
        break;
      case Vaccines.PANLEUKOPENIA:
        state =
            state.copyWith(panleukopenia_vaccine: !state.panleukopenia_vaccine);
        break;
      case Vaccines.HERPESVIRUSandCALICIVIRUS:
        state = state.copyWith(
            herpesvirus_and_calicivirus_vaccine:
                !state.herpesvirus_and_calicivirus_vaccine);
        break;
    }
  }

  void setPawWeight(num weight) {
    state = state.copyWith(weight: weight);
  }

  void setWeightMeasure() {
    final bool isKg = !state.isKg;
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

  /// Adds the given list of [assets] to the existing assets in the state.
  ///
  /// This method takes a list of [AssetEntity] objects and adds them to the
  /// existing assets in the state. It also retrieves the origin bytes of each
  /// asset and adds them to the [imageBytes] list. The updated state is then
  /// returned.
  ///
  /// The [assets] parameter is a list of [AssetEntity] objects representing the
  /// assets to be added.
  ///
  /// Returns a [Future] that completes when the assets have been added.
  Future<void> addAssets(List<AssetEntity> assets) async {
    setLoading(isLoading: true);
    final List<AssetEntity> images =
        List<AssetEntity>.from(state.assets ?? <AssetEntity>[]);
    final List<String> imageBytes =
        List<String>.from(state.imageBytes ?? <String>[]);
    images.addAll(assets);
    for (final AssetEntity element in images) {
      final Uint8List? bytes = await element.originBytes;
      if (bytes != null) {
        imageBytes.add(base64Encode(bytes));
      }
    }
    state = state.copyWith(
        assets: images, imageBytes: imageBytes, isImageLoading: false);
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
    final AssetEntity asset = await PhotoManager.editor.saveImageWithPath(
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
    final List<AssetEntity> images =
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
    final LocationRepository locationRepository =
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
