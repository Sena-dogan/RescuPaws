import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryResponse with _$CategoryResponse {
  factory CategoryResponse({
    required String? parent_id,
    required int id,
    required String name,
    required String? description,
    required int status,
  }) = _CategoryResponse;

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);
}
