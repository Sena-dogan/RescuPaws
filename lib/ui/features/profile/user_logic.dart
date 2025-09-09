import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'user_ui_model.dart';

part 'user_logic.g.dart';

@riverpod
class UserLogic extends _$UserLogic {
  @override
  UserUiModel build() {
    return UserUiModel(
      user: FirebaseAuth.instance.currentUser,
    );
  }

  bool updateUserImage() {
    ImagePicker()
        .pickImage(source: ImageSource.gallery)
        .then((XFile? value) async {
          throw UnimplementedError();
    });
    setImageLoading();
    return true;
  }

  void setImageLoading({bool isLoading = false}) {
    state = state.copyWith(isImageLoading: isLoading);
  }

  void setLoading({bool isLoading = true}) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setUser({bool isLoading = false}) {
    state = state.copyWith(
        isImageLoading: isLoading, user: FirebaseAuth.instance.currentUser);
  }
}
