import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_ui_model.freezed.dart';
part 'login_ui_model.g.dart';

@freezed
abstract class LoginUiModel with _$LoginUiModel {
  const factory LoginUiModel({
    @Default(false) bool isLoggedIn,
    @Default(false) bool isLoading,
    @Default(null) String? error,
    @Default(null) String? email,
    @Default(null) String? password,
    @Default(null) String? confirmPassword,
    @Default(true) bool isObscure,
    // ignore: invalid_annotation_target
    @JsonKey(includeToJson: false, includeFromJson: false) TextEditingController? numberController,
    // ignore: invalid_annotation_target
    @JsonKey(includeToJson: false, includeFromJson: false) TextEditingController? otpController,
    String? vertificationId,
    int? resendToken,
  }) = _LoginUiModel;

  factory LoginUiModel.fromJson(Map<String, dynamic> json) =>
      _$LoginUiModelFromJson(json);
}
