import 'package:freezed_annotation/freezed_annotation.dart';

part 'swipe_card_ui_model.freezed.dart';

@freezed
class SwipeCardUiModel with _$SwipeCardUiModel {
  factory SwipeCardUiModel({
    @Default(0) int selectedImageIndex,
    @Default(0) int id,
  }) = _SwipeCardUiModel;
}
