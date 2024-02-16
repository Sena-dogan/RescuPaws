import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_model.freezed.dart';
part 'favorite_model.g.dart';

/*
    {
        "id": 16,
        "uid": "user-firebase-uid",
        "class_field_id": 10214,
        "is_favorite": 1,
        "created_at": "2024-01-28T14:56:42.000000Z",
        "updated_at": "2024-01-28T14:56:42.000000Z"
    }
*/

@freezed
class Favorite with _$Favorite {
  const factory Favorite({
    required int? id,
    required String? uid,
    required int? class_field_id,
    required int? is_favorite,
    String? created_at,
    String? updated_at,
  }) = _Favorite;

  factory Favorite.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFromJson(json);
}
