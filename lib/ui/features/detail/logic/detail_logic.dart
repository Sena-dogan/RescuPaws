import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../data/network/paw_entry/paw_entry_repository.dart';
import '../../../../models/paw_entry_detail.dart';
import '../../../../models/user_data.dart';
import '../../../../utils/riverpod_extensions.dart';
import 'detail_ui_model.dart';

part 'detail_logic.g.dart';

@riverpod
Future<GetPawEntryDetailResponse?> fetchPawEntryDetail(
    Ref ref, String classfieldsId) async {
  debugPrint('Id is $classfieldsId');
  final PawEntryRepository pawEntryRepository =
      ref.watch(getPawEntryRepositoryProvider);
  ref.cacheFor(const Duration(minutes: 5));
  final GetPawEntryDetailResponse pawEntryDetailResponse =
      await pawEntryRepository
          .getPawEntryDetail(classfieldsId)
          // ignore: body_might_complete_normally_catch_error
          .catchError((Object error) {
    Logger().e(error);
    ref.read(detailLogicProvider.notifier).setError(error.toString());
  });
  return pawEntryDetailResponse;
}

@Riverpod(keepAlive: true)
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

  void setDetailUser(UserData? user) {
    Logger().i('User is $user');
    state = state.copyWith(
      user: user,
    );
  }

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
    SharePlus.instance.share(ShareParams(text: content));
  }

  void setCurrentImageIndex(int index) {
    state = state.copyWith(currentImageIndex: index);
  }
}
