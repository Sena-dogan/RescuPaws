import 'package:freezed_annotation/freezed_annotation.dart';

part 'images_upload.freezed.dart';
part 'images_upload.g.dart';

@freezed
class ImagesUploads with _$ImagesUploads {
  factory ImagesUploads({
    int? id,
    String? user_id,
    int? class_field_id,
    String? path,
    String? created_at,
    String? updated_at,
    String? deleted_at,
    String? image_url,
  }) = _ImagesUploads;

  factory ImagesUploads.fromJson(Map<String, dynamic> json) =>
      _$ImagesUploadsFromJson(json);
}
