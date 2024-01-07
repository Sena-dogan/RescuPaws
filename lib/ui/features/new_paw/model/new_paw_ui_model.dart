// ignore_for_file: non_constant_identifier_names

import 'package:carousel_slider/carousel_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../models/location_response.dart';

part 'new_paw_ui_model.freezed.dart';

@freezed
abstract class NewPawUiModel with _$NewPawUiModel {
  factory NewPawUiModel({
    @Default(false) bool isImageLoading,
    @Default(null) String? error,
    @Default(0) int? page,
    @Default(<AssetEntity>[]) List<AssetEntity>? assets,
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
    int? education,
    bool? vaccinated,
    String? address,
  }) = _NewPawUiModel;
}
