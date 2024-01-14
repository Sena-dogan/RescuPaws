// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_paw_model.freezed.dart';
part 'new_paw_model.g.dart';

@freezed
class NewPawModel with _$NewPawModel {
  factory NewPawModel({
    List<String>? image,
    String? user_id,
    String? name,
    String? description,
    String? weight,
    int? category_id,
    int? country_id,
    int? city_id,
    int? district_id,
    int? gender,
    String? age,
    int? education,
    @Default(0) int? vaccinated,
    String? address,
  }) = _NewPawModel;

  factory NewPawModel.fromJson(Map<String, dynamic> json) =>
      _$NewPawModelFromJson(json);
}

/*
{
    "status": "error",
    "message": "Validation failed",
    "errors": {
        "image": [
            "Image is required!"
        ]
    }
}
*/
@freezed
class NewPawResponse with _$NewPawResponse {
  factory NewPawResponse({
    required String? status,
    required String message,
    required Map<String, dynamic>? errors,
  }) = _NewPawResponse;

  factory NewPawResponse.fromJson(Map<String, dynamic> json) =>
      _$NewPawResponseFromJson(json);
}
