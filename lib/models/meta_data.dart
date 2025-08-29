import 'package:freezed_annotation/freezed_annotation.dart';

import 'time_models.dart';

part 'meta_data.freezed.dart';
part 'meta_data.g.dart';

@freezed
abstract class Metadata with _$Metadata {
  factory Metadata({
    CreatedAt? createdAt,
    LastLoginAt? lastLoginAt,
    dynamic passwordUpdatedAt,
    LastRefreshAt? lastRefreshAt,
  }) = _Metadata;

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);
}
