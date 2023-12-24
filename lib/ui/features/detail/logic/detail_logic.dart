import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../data/network/paw_entry/paw_entry_repository.dart';
import '../../../../models/paw_entry_detail.dart';
import 'detail_ui_model.dart';

part 'detail_logic.g.dart';

@riverpod
Future<PawEntryDetail?> fetchPawEntryDetail(
    FetchPawEntryDetailRef ref, String classfieldsId) async {
  debugPrint('Id is $classfieldsId');
  final PawEntryRepository pawEntryRepository =
      ref.watch(getPawEntryRepositoryProvider);
  final GetPawEntryDetailResponse pawEntryDetailResponse =
      await pawEntryRepository.getPawEntryDetail(classfieldsId);
  return pawEntryDetailResponse.data;
}

@riverpod
class DetailLogic extends _$DetailLogic {
  DetailUiModel _detailUiModel = DetailUiModel();

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

  void setFavorite() {
    _detailUiModel =
        _detailUiModel.copyWith(isFavorite: !_detailUiModel.isFavorite);
    state = state.copyWith(isFavorite: _detailUiModel.isFavorite);
  }

  void shareContent(String content) {
    Share.share(content);
  }
}
