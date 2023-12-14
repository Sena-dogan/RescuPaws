// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'convert_images.g.dart';
part 'convert_images.freezed.dart';

@freezed
class ConvertImagesRequest with _$ConvertImagesRequest {
  factory ConvertImagesRequest({
    required List<String> base64,
    @Default(0) int isPrivate,
  }) = _ConvertImagesRequest;

  factory ConvertImagesRequest.fromJson(Map<String, dynamic> json) =>
      _$ConvertImagesRequestFromJson(json);
}

@freezed
class ConvertImagesResponse with _$ConvertImagesResponse {
  factory ConvertImagesResponse({
    required List<String> url,
  }) = _ConvertImagesResponse;

  factory ConvertImagesResponse.fromJson(Map<String, dynamic> json) =>
      _$ConvertImagesResponseFromJson(json);
}
