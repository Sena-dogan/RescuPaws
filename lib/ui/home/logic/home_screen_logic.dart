import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/network/paw_entry/paw_entry_repository.dart';
import '../../../models/paw_entry.dart';
import 'home_screen_ui_model.dart';

part 'home_screen_logic.g.dart';

@riverpod
Future<Either<String, GetPawEntryResponse>> fetchPawEntries(
    FetchPawEntriesRef ref) async {
  final PawEntryRepository pawEntryRepository =
      ref.watch(getPawEntryRepositoryProvider);
  final Either<String, GetPawEntryResponse> pawEntries =
      await pawEntryRepository.getPawEntry();
  return pawEntries;
}

@riverpod
class HomeScreenLogic extends _$HomeScreenLogic {
  @override
  HomeScreenUiModel build() {
    return HomeScreenUiModel(
      isLoading: true,
    );
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
  
  
}
