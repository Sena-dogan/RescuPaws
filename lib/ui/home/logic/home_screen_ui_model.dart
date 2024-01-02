import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/paw_entry.dart';

part 'home_screen_ui_model.freezed.dart';

@freezed
class HomeScreenUiModel with _$HomeScreenUiModel {
  factory HomeScreenUiModel({
    @Default(<PawEntry>[]) List<PawEntry> pawEntries,
    @Default(0) int selectedIndex,
    @Default(null) String? errorMessage,
    @Default(false) bool isLoading,
  }) = _HomeScreenUiModel;
}
