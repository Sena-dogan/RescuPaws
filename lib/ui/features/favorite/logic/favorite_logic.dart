import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/network/favorite/favorite_repository.dart';
import '../../../../models/favorite/delete_favorite_response.dart';
import '../../../../models/favorite/delete_favorites_request.dart';
import '../../../../models/favorite/favorite_model.dart';
import '../../../../utils/firebase_utils.dart';
import 'favorite_ui_model.dart';

part 'favorite_logic.g.dart';

@riverpod
Future<GetFavoriteListResponse> fetchFavoriteList(
    FetchFavoriteListRef ref) async {
  final FavoriteRepository favoriteRepository =
      ref.watch(getFavoriteRepositoryProvider);
  final GetFavoriteListResponse favoriteList =
      await favoriteRepository.getFavoriteList();
  final int favFilter = ref.read(favoriteLogicProvider).showFavorite ? 1 : 0;
  final List<Favorite> filteredFavoriteList = favoriteList.data
      .where((Favorite fav) => fav.is_favorite == favFilter)
      .toList();
  return favoriteList.copyWith(data: filteredFavoriteList);
}

@riverpod
Future<DeleteFavoriteResponse> deleteFavorite(
    DeleteFavoriteRef ref, Favorite favorite) async {
  final FavoriteRepository favoriteRepository =
      ref.watch(getFavoriteRepositoryProvider);
  final DeleteFavoriteRequest deleteFavoritesRequest = DeleteFavoriteRequest(
    class_field_id: favorite.classfield!.id,
    uid: currentUserUid,
  );
  final DeleteFavoriteResponse deleteFavoriteResponse =
      await favoriteRepository.deleteFavorite(deleteFavoritesRequest);
  return deleteFavoriteResponse;
}

@riverpod
class FavoriteLogic extends _$FavoriteLogic {
  @override
  FavoriteUiModel build() {
    return const FavoriteUiModel();
  }

  void setError(String errorMessage) => state = state.copyWith(
        errorMessage: errorMessage,
        isLoading: false,
      );

  void setFavoriteList(List<Favorite> favoriteList) => state = state.copyWith(
        favoriteList: favoriteList,
        isLoading: false,
      );

  void setLoading({bool isLoading = true}) => state = state.copyWith(
        isLoading: isLoading,
      );

  void showFavorite({bool showFavorite = true}) => state = state.copyWith(
      showFavorite: showFavorite,
      favoriteList: List<Favorite>.from(state.favoriteList.filter(
          (Favorite fav) => fav.is_favorite == (showFavorite ? 1 : 0))));

  Future<void> deleteFavorite(Favorite favorite) async {
    setLoading();
    final AsyncValue<DeleteFavoriteResponse> deleteFavoriteResponse =
        ref.read(deleteFavoriteProvider(favorite));
    deleteFavoriteResponse.whenData(
      (DeleteFavoriteResponse value) {
        if (value.status == 'success') {
          final List<Favorite> updatedFavoriteList = state.favoriteList
              .where((Favorite element) =>
                  element.classfield!.id != favorite.classfield!.id)
              .toList();
          setFavoriteList(updatedFavoriteList);
        } else {
          setError(value.message ?? 'An error occurred');
        }
      },
    );
  }
}
