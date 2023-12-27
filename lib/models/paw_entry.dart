// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

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
    required User user,
    List<ImagesUploads>? images_uploads,
  }) = _PawEntry;

  factory PawEntry.fromJson(Map<String, dynamic> json) =>
      _$PawEntryFromJson(json);
}

extension PawEntryX on PawEntry {
  String get createdAtFormatted {
    final DateTime createdAt = DateTime.parse(created_at!);
    final String formattedDate =
        '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    return formattedDate;
  }
}

extension GetPawEntryResponseX on GetPawEntryResponse {
  List<PawEntry> get pawEntries => data;
  GetPawEntryResponse randomize() {
    return GetPawEntryResponse(
      data: List<PawEntry>.from(data)..shuffle(),
    );
  }
}
