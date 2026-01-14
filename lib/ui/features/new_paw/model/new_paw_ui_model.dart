// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rescupaws/models/location_response.dart';
import 'package:rescupaws/models/paw_entry.dart';

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
    @Default(<String>[]) List<String> vaccines,
    String? address,
  }) = _NewPawUiModel;
}

// Extension of NewPawUiModel so that we can convert it to PawEntry easily
extension NewPawExtension on NewPawUiModel {
  PawEntry toPawEntry() {
    String weight = this.weight!.toStringAsFixed(1);
    if (isKg) {
      weight = '${this.weight} kg';
    } else {
      weight = '${this.weight} lbs';
    }
    int id = DateTime.now().millisecondsSinceEpoch;
    String createdAt = DateTime.now().toIso8601String();
    return PawEntry(
      id: id,
      address: address,
      age: age,
      /// Using both category_id (species) and sub_category_id (breed)
      category_id: category_id, // species (dog/cat)
      sub_category_id: sub_category_id, // breed
      city_id: city?.id,
      country_id: 1,
      description: description,
      district_id: district?.id,
      education: education,
      gender: gender,
      name: name,
      // Images will be uploaded to Supabase and URLs added by createPawEntry
      image: <String>[],
      user_id: user_id,
      weight: weight,
      vaccines: vaccines,
      created_at: createdAt,
    );
  }
}
