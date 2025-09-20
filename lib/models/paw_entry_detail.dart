// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:rescupaws/data/enums/detail_enums.dart';
import 'package:rescupaws/models/paw_entry.dart';
import 'package:rescupaws/models/vaccine_info.dart';

part 'paw_entry_detail.freezed.dart';
part 'paw_entry_detail.g.dart';

@freezed
abstract class GetPawEntryDetailResponse with _$GetPawEntryDetailResponse {
  factory GetPawEntryDetailResponse({
    required PawEntry? data,
  }) = _GetPawEntryDetailResponse;

  factory GetPawEntryDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPawEntryDetailResponseFromJson(json);
}

extension PawEntryDetailX on PawEntry {
  Gender get genderEnum {
    switch (gender) {
      case 0:
        return Gender.Female;
      case 1:
        return Gender.Male;
      default:
        throw Exception('Invalid gender value');
    }
  }

  HaveorNot get educationEnum {
    switch (education) {
      case 0:
        return HaveorNot.Not;
      case 1:
        return HaveorNot.Have;
      default:
        throw Exception('Invalid education value');
    }
  }

  HaveorNot get vaccinatedEnum {
    switch (vaccine_info?.hasAnyVaccine) {
      case true:
        return HaveorNot.Have;
      case false:
        return HaveorNot.Not;
      default:
        throw Exception('Invalid vaccinated value');
    }
  }

  String get createdAtFormatted {
    DateTime createdAt = DateTime.parse(created_at!);
    String formattedDate =
        '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    return formattedDate;
  }
}

extension GetPawEntryDetailResponseX on GetPawEntryDetailResponse {
  PawEntry? get pawEntryDetail => data;
}
