import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/network/paw_entry/paw_entry_repository.dart';
import '../../../models/paw_entry.dart';
import '../../../utils/riverpod_extensions.dart';
import '../swipe_card/swipe_card_logic.dart';
import 'home_screen_ui_model.dart';

part 'home_screen_logic.g.dart';

@riverpod
Future<GetPawEntryResponse> fetchPawEntries(FetchPawEntriesRef ref) async {
  /// OLMMM BU COK GUZEL BIR SEY
  ref.cacheFor(const Duration(minutes: 5));
  final PawEntryRepository pawEntryRepository =
      ref.watch(getPawEntryRepositoryProvider);
  GetPawEntryResponse pawEntries = await pawEntryRepository.getPawEntry();
  pawEntries = pawEntries.randomize();
  ref
      .read(swipeCardLogicProvider.notifier)
      .setId(pawEntries.data.firstOrNull?.id ?? 0);
  return pawEntries;
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
}
