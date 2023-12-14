import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/network/utils/utils_repository.dart';
import '../../../data/network/utils/utils_rest_client.dart';
import '../../../data/network/utils_api.dart';
import '../../../di/components/service_locator.dart';
import '../../../models/convert_images.dart';
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
    final UtilsApi utilsApi = getIt<UtilsApi>();
    ImagePicker()
        .pickImage(source: ImageSource.gallery)
        .then((XFile? value) async {
      setLoading(isLoading: true);
      // debugPrint base64 encoded image
      final File file = File(value!.path);
      final String base64Image = base64Encode(file.readAsBytesSync());
      final ConvertImagesRequest request =
          ConvertImagesRequest(base64: <String>[base64Image]);
      final Either<Object, ConvertImagesResponse> response =
          await utilsApi.convertImages(request);
      response.fold((Object error) {
        debugPrint('error: $error');
        setLoading();
        return false;
      }, (ConvertImagesResponse response) async {
        debugPrint('response: ${response.url}');
        await FirebaseAuth.instance.currentUser!.updatePhotoURL(response.url[0]);
        setUser();
      });
    });
    return true;
  }

  void setLoading({bool isLoading = false}) {
    state = state.copyWith(isImageLoading: isLoading);
  }

  void setUser({bool isLoading = false}) {
    state = state.copyWith(
        isImageLoading: isLoading, user: FirebaseAuth.instance.currentUser);
  }
}
