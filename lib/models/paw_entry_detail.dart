// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/enums/detail_enums.dart';
import 'category_model.dart';
import 'images_upload.dart';
import 'user.dart';
import 'user_data.dart';

part 'paw_entry_detail.freezed.dart';
part 'paw_entry_detail.g.dart';

@freezed
abstract class GetPawEntryDetailResponse with _$GetPawEntryDetailResponse {
  factory GetPawEntryDetailResponse({
    required PawEntryDetail? data,
    UserData? userData,
    CategoryResponse? category,
  }) = _GetPawEntryDetailResponse;

  factory GetPawEntryDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPawEntryDetailResponseFromJson(json);
}

@freezed
abstract class PawEntryDetail with _$PawEntryDetail {
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
    int? rabies_vaccine,
    int? distemper_vaccine,
    int? hepatitis_vaccine,
    int? parvovirus_vaccine,
    int? bordotella_vaccine,
    int? leptospirosis_vaccine,
    int? panleukopenia_vaccine,
    int? herpesvirus_and_calicivirus_vaccine,
    User? user,
    List<ImagesUploads>? images_uploads,
  }) = _PawEntryDetail;

  factory PawEntryDetail.fromJson(Map<String, dynamic> json) =>
      _$PawEntryDetailFromJson(json);
}

extension PawEntryDetailX on PawEntryDetail {
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
    switch (vaccinated) {
      case 0:
        return HaveorNot.Have;
      case 1:
        return HaveorNot.Not;
      default:
        throw Exception('Invalid vaccinated value');
    }
  }

  String get createdAtFormatted {
    final DateTime createdAt = DateTime.parse(created_at!);
    final String formattedDate =
        '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    return formattedDate;
  }
}

extension GetPawEntryDetailResponseX on GetPawEntryDetailResponse {
  PawEntryDetail? get pawEntryDetail => data;
}
