// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../models/location_response.dart';
import '../../../../models/new_paw_model.dart';

part 'new_paw_ui_model.freezed.dart';

@freezed
abstract class NewPawUiModel with _$NewPawUiModel {
  factory NewPawUiModel({
    @Default(false) bool isImageLoading,
    @Default(true) bool isKg,
    @Default(null) String? error,
    @Default(<AssetEntity>[]) List<AssetEntity>? assets,
    List<String>? imageBytes,
    String? user_id,
    String? name,
    String? description,
    String? category_id,
    String? sub_category_id,
    Country? country,
    City? city,
    District? district,
    int? gender,
    String? age,
    num? weight,
    int? education,
    @Default(false) bool rabies_vaccine,
    @Default(false) bool distemper_vaccine,
    @Default(false) bool hepatitis_vaccine,
    @Default(false) bool parvovirus_vaccine,
    @Default(false) bool bordotella_vaccine,
    @Default(false) bool leptospirosis_vaccine,
    @Default(false) bool panleukopenia_vaccine,
    @Default(false) bool herpesvirus_and_calicivirus_vaccine,
    String? address,
  }) = _NewPawUiModel;
}

// Extension of NewPawUiModel so that we can convert it to NewPawModel easily
extension NewPawExtension on NewPawUiModel {
  NewPawModel toNewPawModel() {
    String weight = this.weight!.toStringAsFixed(1);
    if (isKg) {
      weight = '${this.weight} kg';
    } else {
      weight = '${this.weight} lbs';
    }
    return NewPawModel(
      address: address,
      age: age,

      /// Using both category_id (species) and sub_category_id (breed)
      category_id: category_id, // This will be the species (dog/cat)
      sub_category_id: sub_category_id, // This will be the breed
      city_id: city?.id,
      country_id: 1,
      description: description,
      district_id: district?.id,
      education: education,
      gender: gender,
      name: name,
      image: imageBytes,
      user_id: user_id,
      weight: weight,
      rabies_vaccine: rabies_vaccine ? 1 : 0,
      distemper_vaccine: distemper_vaccine ? 1 : 0,
      hepatitis_vaccine: hepatitis_vaccine ? 1 : 0,
      parvovirus_vaccine: parvovirus_vaccine ? 1 : 0,
      bordotella_vaccine: bordotella_vaccine ? 1 : 0,
      leptospirosis_vaccine: leptospirosis_vaccine ? 1 : 0,
      panleukopenia_vaccine: panleukopenia_vaccine ? 1 : 0,
      herpesvirus_and_calicivirus_vaccine: herpesvirus_and_calicivirus_vaccine ? 1 : 0,
    );
  }
}
