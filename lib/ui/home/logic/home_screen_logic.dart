import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:rescupaws/data/network/favorite/favorite_repository.dart';
import 'package:rescupaws/data/network/paw_entry/paw_entry_repository.dart';
import 'package:rescupaws/models/favorite/create_favorite_request.dart';
import 'package:rescupaws/models/favorite/create_favorite_response.dart';
import 'package:rescupaws/models/paw_entry.dart';
import 'package:rescupaws/ui/home/logic/home_screen_ui_model.dart';
import 'package:rescupaws/ui/home/swipe_card/swipe_card_logic.dart';
import 'package:rescupaws/utils/firebase_utils.dart';
import 'package:rescupaws/utils/riverpod_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_screen_logic.g.dart';

@riverpod
Future<GetPawEntryResponse> fetchPawEntries(Ref ref) async {
  /// OLMMM BU COK GUZEL BIR SEY
  ref.cacheFor(const Duration(minutes: 5));

  PawEntryRepository pawEntryRepository =
      ref.watch(getPawEntryRepositoryProvider);
  Either<PawEntryError, GetPawEntryResponse> pawEntries =
      await pawEntryRepository.getPawEntry();
  
  return await pawEntries.fold((PawEntryError l) async {
    ref.read(homeScreenLogicProvider.notifier).setError(l.error);
    return GetPawEntryResponse(data: <PawEntry>[]);
  }, (GetPawEntryResponse pawEntries) async {
    // No conversion needed - using images field directly
    GetPawEntryResponse updatedResponse = GetPawEntryResponse(data: pawEntries.data);
    GetPawEntryResponse randomizedResponse = updatedResponse.randomize();
    
    ref
        .read(swipeCardLogicProvider.notifier)
        .setId(randomizedResponse.data.firstOrNull?.id ?? 0);
    ref.read(homeScreenLogicProvider.notifier).setPawEntries(randomizedResponse.data);
    Logger().i('Paw entries fetched successfully.');
    return randomizedResponse;
  });
}

@riverpod

/// Fetches the paw entries of the current user.
Future<GetPawEntryResponse> fetchUserPawEntries(Ref ref) async {
  PawEntryRepository pawEntryRepository =
      ref.watch(getPawEntryRepositoryProvider);
  Either<PawEntryError, GetPawEntryResponse> pawEntries =
      await pawEntryRepository.getPawEntryById();
  
  return await pawEntries.fold((PawEntryError l) async {
    return GetPawEntryResponse(data: <PawEntry>[]);
  }, (GetPawEntryResponse pawEntries) async {
    // No conversion needed - using images field directly
    debugPrint('User paw entries fetched successfully.');
    return GetPawEntryResponse(data: pawEntries.data);
  });
}

@riverpod
Future<CreateFavoriteResponse> createFavorite(
    Ref ref, CreateFavoriteRequest request) async {
  FavoriteRepository favoriteRepository =
      ref.watch(getFavoriteRepositoryProvider);
  CreateFavoriteResponse createFavoriteResponse =
      await favoriteRepository.createFavorite(request);
  return createFavoriteResponse;
}

@riverpod
class HomeScreenLogic extends _$HomeScreenLogic {
  @override
  HomeScreenUiModel build() {
    return HomeScreenUiModel();
  }

  void setError(String errorMessage) => state = state.copyWith(
        errorMessage: errorMessage,
        isLoading: false,
      );

  void setPawEntries(List<PawEntry> pawEntries) => state = state.copyWith(
        pawEntries: pawEntries,
        isLoading: false,
      );

  void setLoading() => state = state.copyWith(
        isLoading: true,
      );

  void setTap(int index) => state = state.copyWith(
        selectedImageIndex: index,
      );

  void setSelectedCard(int index) {
    state = state.copyWith(
      selectedCardIndex: index,
      selectedImageIndex:
          0, // Reset the image index when a new card is selected
    );
  }

  void setSelectedImageIndex(int cardIndex, int imageIndex) {
    List<PawEntry> pawEntries = List<PawEntry>.from(state.pawEntries);
    PawEntry pawEntry = pawEntries[cardIndex];
    pawEntries[cardIndex] = pawEntry.copyWith(selectedImageIndex: imageIndex);
    state = state.copyWith(pawEntries: pawEntries);
  }

  void setFavorite(int id, bool isFavorite) {
    ref.read(
      createFavoriteProvider(
        CreateFavoriteRequest(
            uid: currentUserUid,
            classFieldId: id,
            isFavorite: isFavorite ? 1 : 0),
      ),
    );
  }
}
