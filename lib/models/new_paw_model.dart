// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_paw_model.freezed.dart';
part 'new_paw_model.g.dart';

@freezed
class NewPawModel with _$NewPawModel {
  factory NewPawModel({
    List<String>? images,
    String? user_id,
    String? name,
    String? description,
    int? category_id,
    int? country_id,
    int? city_id,
    int? district_id,
    bool? gender,
    String? age,
    bool? education,
    bool? vaccinated,
    String? address,
  }) = _NewPawModel;

  factory NewPawModel.fromJson(Map<String, dynamic> json) =>
      _$NewPawModelFromJson(json);
}
