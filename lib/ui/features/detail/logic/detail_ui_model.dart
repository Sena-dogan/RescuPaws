import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/paw_entry_detail.dart';
import '../../../../models/user_data.dart';

part 'detail_ui_model.freezed.dart';

@freezed
abstract class DetailUiModel with _$DetailUiModel {
  factory DetailUiModel({
    @Default(<PawEntryDetail>[]) List<PawEntryDetail> pawEntryDetails,
    @Default(null) String? errorMessage,
    @Default(false) bool isLoading,
    @Default(false) bool isFavorite,
    @Default(0) int currentImageIndex,
    UserData? user,
  }) = _DetailUiModel;
}
