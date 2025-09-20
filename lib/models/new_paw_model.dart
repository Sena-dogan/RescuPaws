import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_paw_model.freezed.dart';
part 'new_paw_model.g.dart';

@freezed
abstract class NewPawModel with _$NewPawModel {
  factory NewPawModel({
    List<String>? image,
    @JsonKey(name: 'user_id') String? userId,
    String? name,
    String? description,
    String? weight,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'sub_category_id') String? subCategoryId,
    @JsonKey(name: 'country_id') int? countryId,
    @JsonKey(name: 'city_id') int? cityId,
    @JsonKey(name: 'district_id') int? districtId,
    int? gender,
    String? age,
    int? education,
    @JsonKey(name: 'rabies_vaccine') int? rabiesVaccine,
    @JsonKey(name: 'distemper_vaccine') int? distemperVaccine,
    @JsonKey(name: 'hepatitis_vaccine') int? hepatitisVaccine,
    @JsonKey(name: 'parvovirus_vaccine') int? parvovirusVaccine,
    @JsonKey(name: 'bordotella_vaccine') int? bordotellaVaccine,
    @JsonKey(name: 'leptospirosis_vaccine') int? leptospirosisVaccine,
    @JsonKey(name: 'panleukopenia_vaccine') int? panleukopeniaVaccine,
    @JsonKey(name: 'herpesvirus_and_calicivirus_vaccine') int? herpesvirusAndCalicivirusVaccine,
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
abstract class NewPawResponse with _$NewPawResponse {
  factory NewPawResponse({
    required String? status,
    required String message,
    required Map<String, dynamic>? errors,
  }) = _NewPawResponse;

  factory NewPawResponse.fromJson(Map<String, dynamic> json) =>
      _$NewPawResponseFromJson(json);
}
