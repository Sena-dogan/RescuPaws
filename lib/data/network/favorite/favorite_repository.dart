import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../di/components/service_locator.dart';
import '../../../models/favorite/create_favorite_request.dart';
import '../../../models/favorite/create_favorite_response.dart';
import '../../../models/favorite/delete_favorite_response.dart';
import '../../../models/favorite/delete_favorites_request.dart';
import '../../../models/favorite/favorite_model.dart';
import '../favorite_api.dart';

part 'favorite_repository.g.dart';

class FavoriteRepository {
  FavoriteRepository(this._favoriteApi);
  final FavoriteApi _favoriteApi;

  Future<List<Favorite>> getFavoriteList() async {
    final List<Favorite> favoriteList = await _favoriteApi.getFavoriteList();
    return favoriteList;
  }

  Future<CreateFavoriteResponse> createFavorite(CreateFavoriteRequest request) async {
    final CreateFavoriteResponse response = await _favoriteApi.addFavorite(request);
    return response;
  }

  Future<DeleteFavoriteResponse> deleteFavorite(
      DeleteFavoriteRequest request) async {
    final DeleteFavoriteResponse response = await _favoriteApi.removeFavorite(request);
    return response;
  }
}

@riverpod
FavoriteRepository getFavoriteRepository(GetFavoriteRepositoryRef ref) {
  final FavoriteApi favoriteApi = getIt<FavoriteApi>();
  return FavoriteRepository(favoriteApi);
}
