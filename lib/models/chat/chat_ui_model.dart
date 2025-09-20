import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:rescupaws/models/user_data.dart';

part 'chat_ui_model.freezed.dart';

@freezed
abstract class ChatUiModel with _$ChatUiModel {
  factory ChatUiModel({
    @Default(null) String? errorMessage,
    @Default(false) bool isLoading,
    UserData? user,
  }) = _ChatUiModel;
}
