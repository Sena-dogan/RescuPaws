import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_favorite_response.freezed.dart';
part 'delete_favorite_response.g.dart';

@freezed
abstract class DeleteFavoriteResponse with _$DeleteFavoriteResponse {
  const factory DeleteFavoriteResponse({
    required String? status,
    required String? message,
  }) = _DeleteFavoriteResponse;

  factory DeleteFavoriteResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteFavoriteResponseFromJson(json);
}
