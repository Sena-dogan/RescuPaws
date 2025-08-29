import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_favorite_request.freezed.dart';
part 'create_favorite_request.g.dart';

@freezed
abstract class CreateFavoriteRequest with _$CreateFavoriteRequest {
  const factory CreateFavoriteRequest({
    required String? uid,
    required int class_field_id,
    /// 1 for favorite, 0 for unfavorite
    required int is_favorite,
  }) = _CreateFavoriteRequest;

  factory CreateFavoriteRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFavoriteRequestFromJson(json);
}
