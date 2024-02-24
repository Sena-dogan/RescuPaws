import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/favorite/favorite_model.dart';

part 'favorite_ui_model.freezed.dart';

@freezed
class FavoriteUiModel with _$FavoriteUiModel {
  const factory FavoriteUiModel({
    @Default(true) bool showFavorite, 
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    @Default(<Favorite>[]) List<Favorite> favoriteList,
  }) = _FavoriteUiModel;
}
