import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'new_paw_ui_model.dart';

part 'new_paw_logic.g.dart';

@riverpod
class NewPawLogic extends _$NewPawLogic {
  @override
  NewPawUiModel build() {
    return NewPawUiModel(
      user_id: FirebaseAuth.instance.currentUser!.uid,
    );
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
