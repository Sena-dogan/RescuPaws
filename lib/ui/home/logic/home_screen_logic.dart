import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/network/favorite/favorite_repository.dart';
import '../../../data/network/paw_entry/paw_entry_repository.dart';
import '../../../models/favorite/create_favorite_request.dart';
import '../../../models/favorite/create_favorite_response.dart';
import '../../../models/paw_entry.dart';
import '../../../utils/firebase_utils.dart';
import '../../../utils/riverpod_extensions.dart';
import '../swipe_card/swipe_card_logic.dart';
import 'home_screen_ui_model.dart';

part 'home_screen_logic.g.dart';

@riverpod
Future<GetPawEntryResponse> fetchPawEntries(Ref ref) async {
  /// OLMMM BU COK GUZEL BIR SEY
  ref.cacheFor(const Duration(minutes: 5));

  final PawEntryRepository pawEntryRepository =
      ref.watch(getPawEntryRepositoryProvider);
  final Either<PawEntryError, GetPawEntryResponse> pawEntries =
      await pawEntryRepository.getPawEntry();
  
  return await pawEntries.fold((PawEntryError l) async {
    ref.read(homeScreenLogicProvider.notifier).setError(l.error);
    return GetPawEntryResponse(data: <PawEntry>[]);
  }, (GetPawEntryResponse pawEntries) async {
    // No conversion needed - using images field directly
    final GetPawEntryResponse updatedResponse = GetPawEntryResponse(data: pawEntries.data);
    final GetPawEntryResponse randomizedResponse = updatedResponse.randomize();
    
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
  final PawEntryRepository pawEntryRepository =
      ref.watch(getPawEntryRepositoryProvider);
  final Either<PawEntryError, GetPawEntryResponse> pawEntries =
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
  final FavoriteRepository favoriteRepository =
      ref.watch(getFavoriteRepositoryProvider);
  final CreateFavoriteResponse createFavoriteResponse =
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
    final List<PawEntry> pawEntries = List<PawEntry>.from(state.pawEntries);
    final PawEntry pawEntry = pawEntries[cardIndex];
    pawEntries[cardIndex] = pawEntry.copyWith(selectedImageIndex: imageIndex);
    state = state.copyWith(pawEntries: pawEntries);
  }

  void setFavorite(int id, bool isFavorite) {
    ref.read(
      createFavoriteProvider(
        CreateFavoriteRequest(
            uid: currentUserUid,
            class_field_id: id,
            is_favorite: isFavorite ? 1 : 0),
      ),
    );
  }
}
