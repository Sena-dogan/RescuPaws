// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'categories_response.freezed.dart';
part 'categories_response.g.dart';

@freezed
class GetCategoriesResponse with _$GetCategoriesResponse {
  factory GetCategoriesResponse({
    required List<Category> data,
  }) = _CategoriesResponse;

  factory GetCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCategoriesResponseFromJson(json);
}

@freezed
class Category with _$Category {
  factory Category({
    required int? parent_id,
    required int id,
    required String name,
    required String description,
    required int status,
    required String created_at,
    required String? updated_at,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}