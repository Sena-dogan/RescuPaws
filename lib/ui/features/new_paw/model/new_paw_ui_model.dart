// ignore_for_file: non_constant_identifier_names

import 'package:carousel_slider/carousel_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../models/location_response.dart';
import '../../../../models/new_paw_model.dart';

part 'new_paw_ui_model.freezed.dart';

@freezed
abstract class NewPawUiModel with _$NewPawUiModel {
  factory NewPawUiModel({
    @Default(false) bool isImageLoading,
    @Default(null) String? error,
    @Default(0) int? page,
    @Default(<AssetEntity>[]) List<AssetEntity>? assets,
    List<String>? imageBytes,
    CarouselController? carouselController,
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
    String? weight,
    int? education,
    @Default(0) int? vaccinated,
    String? address,
  }) = _NewPawUiModel;
}

// Extension of NewPawUiModel so that we can convert it to NewPawModel easily
extension NewPawExtension on NewPawUiModel {
  NewPawModel toNewPawModel() {
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
