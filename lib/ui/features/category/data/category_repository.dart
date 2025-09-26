
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rescupaws/models/categories_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_repository.g.dart';

class CategoryRepository {
  CategoryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Get all categories (dogs and cats)
  /// This returns the species as categories
  Future<GetCategoriesResponse> getCategories() async {
    try {
      // Get unique species from the breeds collection
      QuerySnapshot<Map<String, dynamic>> snapshot = 
          await _firestore.collection('breeds').get();
      
      Set<String> speciesSet = <String>{};
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();
        String? species = data['species'] as String?;
        if (species != null) {
          speciesSet.add(species);
        }
      }

      // Create categories for each species
      List<Category> categories = speciesSet.map((String species) {
        return Category(
          id: species, // Use species as ID (dog, cat)
          name: _getSpeciesDisplayName(species),
          species: species,
          slug: species,
        );
      }).toList();

      return GetCategoriesResponse(data: categories);
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  /// Get subcategories (breeds) for a specific species
  Future<GetCategoriesResponse> getSubCategories(String speciesId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('breeds')
          .where('species', isEqualTo: speciesId)
          .get();

      List<Category> breeds = snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return Category.fromFirestore(doc.id, doc.data());
          })
          .toList()
          ..sort((Category a, Category b) => a.name.compareTo(b.name));

      return GetCategoriesResponse(data: breeds);
    } catch (e) {
      throw Exception('Failed to fetch subcategories for $speciesId: $e');
    }
  }

  /// Helper method to get display name for species
  String _getSpeciesDisplayName(String species) {
    switch (species.toLowerCase()) {
      case 'dog':
        return 'Köpek';
      case 'cat':
        return 'Kedi';
      default:
        return species.toUpperCase();
    }
  }
}

@riverpod
CategoryRepository getCategoryRepository(Ref ref) {
  return CategoryRepository();
}
