import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_ui_model.freezed.dart';

@freezed
abstract class UserUiModel with _$UserUiModel {
  const factory UserUiModel({
    @Default(false) bool isImageLoading,
    @Default(null) User? user,
  }) = _UserUiModel;

}
