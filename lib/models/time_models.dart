import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_models.freezed.dart';
part 'time_models.g.dart';

@freezed
abstract class CreatedAt with _$CreatedAt {
  factory CreatedAt({
    String? date,
    @JsonKey(name: 'timezone_type') int? timezoneType,
    String? timezone,
  }) = _CreatedAt;

  factory CreatedAt.fromJson(Map<String, dynamic> json) =>
      _$CreatedAtFromJson(json);
}

// Similar classes for LastLoginAt and LastRefreshAt
@freezed
abstract class LastLoginAt with _$LastLoginAt {
  factory LastLoginAt({
    String? date,
    @JsonKey(name: 'timezone_type') int? timezoneType,
    String? timezone,
  }) = _LastLoginAt;

  factory LastLoginAt.fromJson(Map<String, dynamic> json) =>
      _$LastLoginAtFromJson(json);
}

@freezed
abstract class LastRefreshAt with _$LastRefreshAt {
  factory LastRefreshAt({
    String? date,
    @JsonKey(name: 'timezone_type') int? timezoneType,
    String? timezone,
  }) = _LastRefreshAt;

  factory LastRefreshAt.fromJson(Map<String, dynamic> json) =>
      _$LastRefreshAtFromJson(json);
}
