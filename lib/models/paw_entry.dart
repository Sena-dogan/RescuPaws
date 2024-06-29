// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/enums/paw_entry_status.dart';
import 'images_upload.dart';
import 'user.dart';

part 'paw_entry.freezed.dart';
part 'paw_entry.g.dart';

@freezed
class GetPawEntryResponse with _$GetPawEntryResponse {
  factory GetPawEntryResponse({
    required List<PawEntry> data,
  }) = _GetPawEntryResponse;

  factory GetPawEntryResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPawEntryResponseFromJson(json);
}

@freezed
class PawEntryError with _$PawEntryError {
  factory PawEntryError({
    required String error,
  }) = _PawEntryError;

  factory PawEntryError.fromJson(Map<String, dynamic> json) =>
      _$PawEntryErrorFromJson(json);
}

@freezed
class PawEntry with _$PawEntry {
  factory PawEntry({
    required int id,
    String? user_id,
    String? name,
    String? description,
    int? category_id,
    @Default(0) int? status,
    int? country_id,
    int? city_id,
    int? district_id,
    String? address,
    dynamic deleted_at,
    String? created_at,
    String? updated_at,
    User? user,
    List<ImagesUploads>? images_uploads,
    @Default(0) int selectedImageIndex, // Add this line
  }) = _PawEntry;

  factory PawEntry.fromJson(Map<String, dynamic> json) =>
      _$PawEntryFromJson(json);
}
/*
Paw entry json example 
{
  id: 1,
  name: "Kedi",
  description: "Bir kedi buldum",
  category_id: 1,
  main_image: "https://patiicinsecilmisanaresim.jpg",
  address: "Kadıköy",
  tags: [],
}
*/

extension PawEntryX on PawEntry {
  String get createdAtFormatted {
    final DateTime createdAt = DateTime.parse(created_at!);
    final String formattedDate =
        '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    return formattedDate;
  }

  PawEntryStatus get statusEnum => PawEntryStatus.fromValue(status!);
}

extension GetPawEntryResponseX on GetPawEntryResponse {
  List<PawEntry> get pawEntries => data;
  GetPawEntryResponse randomize() {
    return GetPawEntryResponse(
      data: List<PawEntry>.from(data)..shuffle(),
    );
  }
}
