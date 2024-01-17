import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/network/category/category_repository.dart';
import '../../../../data/network/paw_entry/paw_entry_repository.dart';
import '../../../../models/categories_response.dart';
import '../../../../models/location_response.dart';
import '../../../../models/new_paw_model.dart';
import '../../../../utils/riverpod_extensions.dart';
import '../model/new_paw_ui_model.dart';

part 'new_paw_logic.g.dart';

@riverpod
Future<List<Category>> fetchCategories(FetchCategoriesRef ref) async {
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
    FetchSubCategoriesRef ref, int categoryId) async {
  ref.keepAlive();
  final CategoryRepository categoryRepository =
      ref.watch(getCategoryRepositoryProvider);
  final GetCategoriesResponse categories =
      await categoryRepository.getSubCategories(categoryId);
  return categories.data;
}

@riverpod
Future<NewPawResponse> createPawEntry(
    CreatePawEntryRef ref, NewPawModel newPawModel) async {
  Logger().i('new paw model: $newPawModel');
  final PawEntryRepository pawEntryRepository =
      ref.watch(getPawEntryRepositoryProvider);
  final NewPawResponse pawEntry =
      await pawEntryRepository.createPawEntry(newPawModel);
  return pawEntry;
}

@riverpod
Future<PermissionState> fetchPermissionState(
    FetchPermissionStateRef ref) async {
  ref.keepAlive();
  final PermissionState ps = await PhotoManager.requestPermissionExtend();
  debugPrint('permission state: $ps');
  return ps;
}

@riverpod
Future<List<AssetEntity>> fetchImages(FetchImagesRef ref) async {
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

  void setPawWeight(num weight) {
    state = state.copyWith(weight: weight);
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
    final AssetEntity? asset = await PhotoManager.editor.saveImageWithPath(
      file.path,
      title: 'paw',
    );
    addImage(asset!);
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

  void setCategoryId(int categoryId) {
    state = state.copyWith(category_id: categoryId);
  }

  void setSubCategoryId(int subCategoryId) {
    state = state.copyWith(sub_category_id: subCategoryId);
  }

  void setCountry(Country? country) {
    state = state.copyWith(country: country);
  }

  void setCity(City? city) {
    state = state.copyWith(city: city);
  }

  void setDistrict(District? district) {
    state = state.copyWith(district: district);
  }

  void setAddress(String? address) {
    state = state.copyWith(address: address);
  }
}
