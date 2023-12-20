import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/network/paw_entry/paw_entry_repository.dart';
import '../../../../models/paw_entry_detail.dart';
import '../../../../utils/riverpod_extensions.dart';
import 'detail_ui_model.dart';

part 'detail_logic.g.dart';

@riverpod
Future<GetPawEntryDetailResponse> fetchPawEntryDetail(
    FetchPawEntryDetailRef ref, String classfieldsId) async {
  ref.cacheFor(const Duration(minutes: 5));
  final PawEntryRepository pawEntryRepository =
      ref.watch(getPawEntryRepositoryProvider);
  final GetPawEntryDetailResponse pawEntryDetail =
      await pawEntryRepository.getPawEntryDetail(classfieldsId);
  return pawEntryDetail;
}

@riverpod
class DetailLogic extends _$DetailLogic {
  @override
  DetailUiModel build() {
    return DetailUiModel();
  }

  void setError(String errorMessage) => state = state.copyWith(
        errorMessage: errorMessage,
        isLoading: false,
      );

  void setPawEntryDetails(List<PawEntryDetail> pawEntryDetails) =>
      state = state.copyWith(
        pawEntryDetails: pawEntryDetails,
        isLoading: false,
      );

  void setLoading() => state = state.copyWith(
        isLoading: true,
      );
}
