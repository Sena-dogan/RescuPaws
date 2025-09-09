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
sealed class Category with _$Category {
  factory Category({
    required String id, // Changed to String to match Firestore document IDs
    required String name,
    required String species, // 'cat' or 'dog'
    required String slug,
    String? parent_id, // Keep for compatibility, can represent species
    String? image,
    String? description,
    Map<String, dynamic>? attributes, // Breed attributes
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  // Convenience factory for creating from Firestore breed document
  factory Category.fromFirestore(String docId, Map<String, dynamic> data) {
    return Category(
      id: docId,
      name: data['name'] as String,
      species: data['species'] as String,
      slug: data['slug'] as String,
      parent_id: data['species'] as String, // Use species as parent for compatibility
      image: data['imageUrl'] as String?, // Optional image URL
      description: data['description'] as String?,
      attributes: data['attributes'] as Map<String, dynamic>?,
    );
  }
}
