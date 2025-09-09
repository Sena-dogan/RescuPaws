import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_favorites_request.freezed.dart';
part 'delete_favorites_request.g.dart';

@freezed
abstract class DeleteFavoriteRequest with _$DeleteFavoriteRequest {
  const factory DeleteFavoriteRequest({
    required String? uid,
    required int class_field_id,
  }) = _DeleteFavoritesRequest;

  factory DeleteFavoriteRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteFavoriteRequestFromJson(json);
}
