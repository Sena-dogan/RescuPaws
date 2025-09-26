import 'package:rescupaws/data/network/favorite/favorite_repository.dart';
import 'package:rescupaws/models/favorite/delete_favorite_response.dart';
import 'package:rescupaws/models/favorite/delete_favorites_request.dart';
import 'package:rescupaws/models/favorite/favorite_model.dart';
import 'package:rescupaws/ui/features/favorite/logic/favorite_ui_model.dart';
import 'package:rescupaws/utils/firebase_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_logic.g.dart';

@riverpod
Future<GetFavoriteListResponse> fetchFavoriteList(
    Ref ref) async {
  FavoriteRepository favoriteRepository =
      ref.watch(getFavoriteRepositoryProvider);
  GetFavoriteListResponse favoriteList =
      await favoriteRepository.getFavoriteList();
  ref.read(favoriteLogicProvider.notifier).setFavoriteList(favoriteList.data);
  return favoriteList;
}

@riverpod
Future<DeleteFavoriteResponse> deleteFavorite(
    Ref ref, Favorite favorite) async {
  FavoriteRepository favoriteRepository =
      ref.watch(getFavoriteRepositoryProvider);
  DeleteFavoriteRequest deleteFavoritesRequest = DeleteFavoriteRequest(
    classFieldId: favorite.classFieldId!,
    uid: currentUserUid,
  );
  DeleteFavoriteResponse deleteFavoriteResponse =
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
        showFavorite: !state.showFavorite,
      );

  Future<void> deleteFavorite(Favorite favorite) async {
    setLoading();
    AsyncValue<DeleteFavoriteResponse> deleteFavoriteResponse = ref.read(deleteFavoriteProvider(favorite));
    deleteFavoriteResponse.whenData(
      (DeleteFavoriteResponse value) {
        if (value.status == 'success') {
          List<Favorite> updatedFavoriteList = state.favoriteList
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
