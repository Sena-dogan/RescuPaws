import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:rescupaws/models/favorite/favorite_model.dart';

part 'read_favorites_response.freezed.dart';
part 'read_favorites_response.g.dart';

@freezed
abstract class ReadFavoritesResponse with _$ReadFavoritesResponse {
  const factory ReadFavoritesResponse({
    required List<Favorite>? data,
  }) = _ReadFavoritesResponse;

  factory ReadFavoritesResponse.fromJson(Map<String, dynamic> json) =>
      _$ReadFavoritesResponseFromJson(json);
}
