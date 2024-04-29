import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/chat/chat_ui_model.dart';
import '../../../../models/user_data.dart';
import '../../../../utils/riverpod_extensions.dart';
import '../../detail/logic/detail_logic.dart';
part 'chat_logic.g.dart';

@riverpod
class ChatLogic extends _$ChatLogic {
  @override
  ChatUiModel build() {
    ref.cacheFor(const Duration(hours: 1));
    final UserData? user = ref.watch(detailLogicProvider).user;
    return ChatUiModel(
      user: user,
    );
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
}
