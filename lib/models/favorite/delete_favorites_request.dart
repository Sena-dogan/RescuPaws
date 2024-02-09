import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_favorites_request.freezed.dart';
part 'delete_favorites_request.g.dart';

@freezed
class DeleteFavoritesRequest with _$DeleteFavoritesRequest {
  const factory DeleteFavoritesRequest({
    required String? uid,
    required int class_field_id,
  }) = _DeleteFavoritesRequest;

  factory DeleteFavoritesRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteFavoritesRequestFromJson(json);
}