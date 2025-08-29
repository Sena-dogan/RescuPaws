// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'categories_response.freezed.dart';
part 'categories_response.g.dart';

@freezed
abstract class GetCategoriesResponse with _$GetCategoriesResponse {
  factory GetCategoriesResponse({
    required List<Category> data,
  }) = _CategoriesResponse;

  factory GetCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCategoriesResponseFromJson(json);
}

@freezed
abstract class Category with _$Category {
  factory Category({
    /// Bruh why parent_id is String when id is int
    required String? parent_id,
    required int id,
    required String name,
    required String? image,
    required String? description,
    required int status,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
