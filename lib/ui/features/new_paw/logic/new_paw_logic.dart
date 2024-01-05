import 'package:firebase_auth/firebase_auth.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/network/category/category_repository.dart';
import '../../../../models/categories_response.dart';
import '../../../../models/location_response.dart';
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
Future<PermissionState> fetchPermissionState(
    FetchPermissionStateRef ref) async {
  ref.keepAlive();
  final PermissionState ps = await PhotoManager.requestPermissionExtend();
  return ps;
}

@riverpod
Future<List<AssetEntity>> fetchImages(FetchImagesRef ref) async {
  ref.cacheFor(const Duration(minutes: 10));
  final List<AssetEntity> assets = await PhotoManager.getAssetListRange(
    start: 0,
    end: 10,
    type: RequestType.image,
    filterOption: FilterOptionGroup(
      createTimeCond: DateTimeCond(
        min: DateTime.now().subtract(const Duration(days: 2)),
        max: DateTime.now(),
      ),
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

  void addImage(AssetEntity image) {
    final List<AssetEntity> images =
        List<AssetEntity>.from(state.assets ?? <AssetEntity>[]);
    if (images.contains(image))
      images.remove(image);
    else
      images.add(image);
    state = state.copyWith(assets: images);
  }

  bool isSelected(AssetEntity asset) {
    return state.assets?.contains(asset) ?? false;
  }

  void nextPage() {
    state = state.copyWith(page: state.page! + 1);
  }

  void previousPage() {
    state = state.copyWith(page: state.page! - 1);
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
}
