// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_paw_ui_model.freezed.dart';

@freezed
abstract class NewPawUiModel with _$NewPawUiModel {
  factory NewPawUiModel({
    @Default(false) bool isImageLoading,
    @Default(null) String? error,
    @Default(0) int? page,
    List<String>? images,
    String? user_id,
    String? name,
    String? description,
    int? category_id,
    int? sub_category_id,
    int? country_id,
    int? city_id,
    int? district_id,
    int? gender,
    String? age,
    int? education,
    bool? vaccinated,
    String? address,
  }) = _NewPawUiModel;
}
