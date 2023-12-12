import 'package:injectable/injectable.dart';

import '../../models/categories_response.dart';
import 'category/category_rest_client.dart';

@injectable
class CategoryApi {
  CategoryApi(this._categoryRestClient);
  final CategoryRestClient _categoryRestClient;

  Future<GetCategoriesResponse> getCategories() async {
    final GetCategoriesResponse categories =
        await _categoryRestClient.getCategories();
    return categories;
  }
}
