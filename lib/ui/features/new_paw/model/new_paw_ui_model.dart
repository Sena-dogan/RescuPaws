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
    int? category_id,
    int? sub_category_id,
    Country? country,
    City? city,
    District? district,
    int? gender,
    String? age,
    num? weight,
    int? education,
    @Default(0) int? vaccinated,
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

      /// Its sub_category_id not category_id in the backend sorry for the confusion
      category_id: sub_category_id,
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
      vaccinated: vaccinated,
    );
  }
}
