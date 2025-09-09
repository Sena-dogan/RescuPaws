import 'package:freezed_annotation/freezed_annotation.dart';

part 'read_favorites_request.freezed.dart';
part 'read_favorites_request.g.dart';

@freezed
abstract class ReadFavoritesRequest with _$ReadFavoritesRequest {
  const factory ReadFavoritesRequest({
    required String? uid,
  }) = _ReadFavoritesRequest;

  factory ReadFavoritesRequest.fromJson(Map<String, dynamic> json) =>
      _$ReadFavoritesRequestFromJson(json);
}
