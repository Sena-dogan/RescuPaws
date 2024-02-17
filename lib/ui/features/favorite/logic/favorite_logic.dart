import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/network/favorite/favorite_repository.dart';
import '../../../../models/favorite/favorite_model.dart';
import '../../../../utils/riverpod_extensions.dart';
import 'favorite_ui_model.dart';

part 'favorite_logic.g.dart';

@riverpod
Future<List<Favorite>?> fetchFavoriteList(FetchFavoriteListRef ref) async {
  final FavoriteRepository favoriteRepository =
      ref.watch(getFavoriteRepositoryProvider);
  ref.cacheFor(const Duration(minutes: 5));
  final List<Favorite> favoriteList = await favoriteRepository.getFavoriteList();
  return favoriteList;
} 

@riverpod
class FavoriteLogic extends _$FavoriteLogic {
  @override
  FavoriteUiModel build() {
    return FavoriteUiModel();
  }

  void setError(String errorMessage) => state = state.copyWith(
        errorMessage: errorMessage,
        isLoading: false,
      );

  void setFavoriteList(List<Favorite> favoriteList) =>
      state = state.copyWith(
        favoriteList: favoriteList,
        isLoading: false,
      );

  void setLoading() => state = state.copyWith(
        isLoading: true,
      );
}
