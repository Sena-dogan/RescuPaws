import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../constants/endpoints.dart';
import '../../../models/favorite/create_favorite_request.dart';
import '../../../models/favorite/create_favorite_response.dart';
import '../../../models/favorite/delete_favorite_response.dart';
import '../../../models/favorite/delete_favorites_request.dart';
import '../../../models/favorite/favorite_model.dart';

part 'favorite_rest_client.g.dart';

@RestApi(baseUrl: Endpoints.baseUrl)
abstract class FavoriteRestClient {
  factory FavoriteRestClient(Dio dio) = _FavoriteRestClient;

  @GET('/favorites/{uid}')
  Future<GetFavoriteListResponse> getFavoriteList(@Path('uid') String uid);

  @POST('/favorites')
  Future<CreateFavoriteResponse> createFavorite(
      @Body() CreateFavoriteRequest request);

  @POST('/favorites/delete')
  Future<DeleteFavoriteResponse> deleteFavorite(
      @Body() DeleteFavoriteRequest request);
}
