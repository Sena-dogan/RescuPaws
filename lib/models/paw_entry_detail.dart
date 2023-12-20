// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

import 'images_upload.dart';
import 'user.dart';

part 'paw_entry_detail.freezed.dart';
part 'paw_entry_detail.g.dart';

@freezed
class GetPawEntryDetailResponse with _$GetPawEntryDetailResponse {
  factory GetPawEntryDetailResponse({
    required PawEntryDetail data,
  }) = _GetPawEntryDetailResponse;

  factory GetPawEntryDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPawEntryDetailResponseFromJson(json);
}

//! TODO: Check nullable fields from the API docs
@freezed
class PawEntryDetail with _$PawEntryDetail {
  factory PawEntryDetail({
    required int id,
    String? user_id,
    String? name,
    String? description,
    String? reject_desc,
    int? category_id,
    @Default(0) int? status,
    int? country_id,
    int? city_id,
    int? district_id,
    String? address,
    int? gender,
    String? age,
    String? weight,
    int? education,
    int? vaccinated,
    dynamic deleted_at,
    String? created_at,
    String? updated_at,
    required User user,
    List<ImagesUploads>? images_uploads,
  }) = _PawEntryDetail;

  factory PawEntryDetail.fromJson(Map<String, dynamic> json) =>
      _$PawEntryDetailFromJson(json);
}

extension PawEntryDetailX on PawEntryDetail {
  String get createdAtFormatted {
    final DateTime createdAt = DateTime.parse(created_at!);
    final String formattedDate =
        '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    return formattedDate;
  }
}

extension GetPawEntryDetailResponseX on GetPawEntryDetailResponse {
  PawEntryDetail get pawEntryDetail => data;
}
