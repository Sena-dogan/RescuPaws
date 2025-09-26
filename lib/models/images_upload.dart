import 'package:freezed_annotation/freezed_annotation.dart';

part 'images_upload.freezed.dart';
part 'images_upload.g.dart';

@freezed
abstract class ImagesUploads with _$ImagesUploads {
  factory ImagesUploads({
    int? id,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'class_field_id') int? classFieldId,
    String? path,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _ImagesUploads;

  factory ImagesUploads.fromJson(Map<String, dynamic> json) =>
      _$ImagesUploadsFromJson(json);
}
