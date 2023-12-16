
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../di/components/service_locator.dart';
import '../../../models/categories_response.dart';
import '../category_api.dart';

part 'category_repository.g.dart';

class CategoryRepository
{
  CategoryRepository(this._categoryApi);
  final CategoryApi _categoryApi;

  Future<GetCategoriesResponse> getCategories() async {
    // Best part of functional programming: no try-catch blocks!
    // Instead, we use Either to return either a String or a PawEntry.
    // If the request fails, we return a String with the error message.
    // If the request succeeds, we return a PawEntry.
    final GetCategoriesResponse categories =
    await _categoryApi.getCategories();
    return categories;
  }

  Future<GetCategoriesResponse> getSubCategories(int id) async {
    final GetCategoriesResponse categories =
    await _categoryApi.getSubCategories(id);
    return categories;
  }
}

@riverpod
CategoryRepository getCategoryRepository(GetCategoryRepositoryRef ref) {
  final CategoryApi categoryApi = getIt<CategoryApi>();
  return CategoryRepository(categoryApi);
}
