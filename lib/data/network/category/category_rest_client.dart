import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../constants/endpoints.dart';
import '../../../models/categories_response.dart';

part 'category_rest_client.g.dart';

@RestApi(baseUrl: Endpoints.baseUrl)
abstract class CategoryRestClient {
  factory CategoryRestClient(Dio dio, {String baseUrl}) = _CategoryRestClient;

  @GET('/categories')
  Future<GetCategoriesResponse> getCategories();

  @GET('/categories/{id}')
  Future<GetCategoriesResponse> getSubCategories(@Path('id') int id);
}
