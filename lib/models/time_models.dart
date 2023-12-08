import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_models.freezed.dart';
part 'time_models.g.dart';

@freezed
class CreatedAt with _$CreatedAt {
  factory CreatedAt({
    String? date,
    int? timezone_type,
    String? timezone,
  }) = _CreatedAt;

  factory CreatedAt.fromJson(Map<String, dynamic> json) =>
      _$CreatedAtFromJson(json);
}

// Similar classes for LastLoginAt and LastRefreshAt
@freezed
class LastLoginAt with _$LastLoginAt {
  factory LastLoginAt({
    String? date,
    int? timezone_type,
    String? timezone,
  }) = _LastLoginAt;

  factory LastLoginAt.fromJson(Map<String, dynamic> json) =>
      _$LastLoginAtFromJson(json);
}

@freezed
class LastRefreshAt with _$LastRefreshAt {
  factory LastRefreshAt({
    String? date,
    int? timezone_type,
    String? timezone,
  }) = _LastRefreshAt;

  factory LastRefreshAt.fromJson(Map<String, dynamic> json) =>
      _$LastRefreshAtFromJson(json);
}
