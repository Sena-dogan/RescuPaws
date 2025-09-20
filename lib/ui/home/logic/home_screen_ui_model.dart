import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:rescupaws/models/paw_entry.dart';

part 'home_screen_ui_model.freezed.dart';

@freezed
abstract class HomeScreenUiModel with _$HomeScreenUiModel {
  factory HomeScreenUiModel({
    @Default(<PawEntry>[]) List<PawEntry> pawEntries,
    @Default(0) int selectedCardIndex,
    @Default(0) int selectedImageIndex,
    @Default(null) String? errorMessage,
    @Default(false) bool isLoading,
  }) = _HomeScreenUiModel;
}
