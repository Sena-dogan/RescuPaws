import 'package:injectable/injectable.dart';

import '../../models/favorite/create_favorite_request.dart';
import '../../models/favorite/create_favorite_response.dart';
import '../../models/favorite/delete_favorite_response.dart';
import '../../models/favorite/delete_favorites_request.dart';
import '../../models/favorite/favorite_model.dart';
import '../../utils/firebase_utils.dart';
import 'favorite/favorite_rest_client.dart';

@injectable
class FavoriteApi {
  FavoriteApi(this._favoriteRestClient);
  final FavoriteRestClient _favoriteRestClient;

  Future<List<Favorite>> getFavoriteList() async {
    final List<Favorite> favoriteList =
        await _favoriteRestClient.getFavoriteList(currentUserUid);
    return favoriteList;
  }

  Future<CreateFavoriteResponse> addFavorite(CreateFavoriteRequest request) async {
    final CreateFavoriteResponse response = await _favoriteRestClient.createFavorite(request);
    return response;
  }

  Future<DeleteFavoriteResponse> removeFavorite(
      DeleteFavoriteRequest request) async {
    final DeleteFavoriteResponse response = await _favoriteRestClient.deleteFavorite(request);
    return response;
  }
}
