import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/network/category/category_repository.dart';
import '../../../../models/categories_response.dart';
import '../model/new_paw_ui_model.dart';

part 'new_paw_logic.g.dart';

@riverpod
Future<List<Category>> fetchCategories(FetchCategoriesRef ref) async {
  /// OLMMM BU COK GUZEL BIR SEY
  final CategoryRepository categoryRepository =
      ref.watch(getCategoryRepositoryProvider);
  final GetCategoriesResponse categories =
      await categoryRepository.getCategories();
  return categories.data;
}

@riverpod
class NewPawLogic extends _$NewPawLogic {
  @override
  NewPawUiModel build() {
    return NewPawUiModel(
      user_id: FirebaseAuth.instance.currentUser!.uid,
    );
  }

  void setError(String error) {
    state = state.copyWith(error: error);
  }

  void setLoading({bool isLoading = false}) {
    state = state.copyWith(isImageLoading: isLoading);
  }

  void setImages(List<String> images) {
    state = state.copyWith(images: images);
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

  void setCountryId(int countryId) {
    state = state.copyWith(country_id: countryId);
  }

  void setCityId(int cityId) {
    state = state.copyWith(city_id: cityId);
  }

  void setDistrictId(int districtId) {
    state = state.copyWith(district_id: districtId);
  }
}
