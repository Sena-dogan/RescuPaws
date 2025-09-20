import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_favorite_request.freezed.dart';
part 'create_favorite_request.g.dart';

@freezed
abstract class CreateFavoriteRequest with _$CreateFavoriteRequest {
  const factory CreateFavoriteRequest({
    required String? uid,
    @JsonKey(name: 'class_field_id') required int classFieldId,
    /// 1 for favorite, 0 for unfavorite
    @JsonKey(name: 'is_favorite') required int isFavorite,
  }) = _CreateFavoriteRequest;

  factory CreateFavoriteRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFavoriteRequestFromJson(json);
}
