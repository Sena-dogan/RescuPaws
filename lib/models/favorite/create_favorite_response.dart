import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_favorite_response.freezed.dart';
part 'create_favorite_response.g.dart';

@freezed
abstract class CreateFavoriteResponse with _$CreateFavoriteResponse {
  const factory CreateFavoriteResponse({
    required String? status,
    required String? message,
  }) = _CreateFavoriteResponse;

  factory CreateFavoriteResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateFavoriteResponseFromJson(json);
}
