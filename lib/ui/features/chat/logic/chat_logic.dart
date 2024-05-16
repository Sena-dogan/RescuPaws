import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/chat/chat_model.dart';
import '../../../../models/chat/chat_ui_model.dart';
import '../../../../models/chat/message.dart';
import '../../../../models/user_data.dart';
import '../../../../utils/riverpod_extensions.dart';
import '../../detail/logic/detail_logic.dart';
import '../service/chat_repository.dart';
part 'chat_logic.g.dart';

final Provider<UserData> currentUserProvider =
    Provider<UserData>((ProviderRef<Object?> ref) {
  return FirebaseAuth.instance.currentUser!.toUserData();
});

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

  // send text message function
  Future<bool> sendTextMessage({
    required String lastMessage,
    required String receiverUserId,
  }) async {
    final ChatRepository chatRepository =
        ref.watch(chatRepositoryProvider.notifier);

    await chatRepository
        .sendTextMessage(
      lastMessage: lastMessage,
      receiverUserId: receiverUserId,
      senderUser: ref.watch(currentUserProvider),
    )
        .catchError((Object error) {
      setError(error.toString());
    });
    return true;
  }

  // get chats list function
  Stream<List<Chat>> getChatsList() {
    final ChatRepository chatRepository =
        ref.watch(chatRepositoryProvider.notifier);
    final UserData senderUser = ref.watch(currentUserProvider);
    return chatRepository.getChatsList(senderUserId: senderUser.uid!);
  }

  // get messages list function
  Stream<List<MessageModel>> getMessagesList(String receiverUserId) {
    final ChatRepository chatRepository =
        ref.watch(chatRepositoryProvider.notifier);
    final UserData senderUser = ref.watch(currentUserProvider);
    return chatRepository.getMessagesList(
      senderUserId: senderUser.uid!,
      receiverUserId: receiverUserId,
    );
  }

  // set chat message seen function
  Future<bool> setChatMessageSeen({
    required String receiverUserId,
    required String messageId,
  }) async {
    final ChatRepository chatRepository =
        ref.watch(chatRepositoryProvider.notifier);
    final UserData user = ref.watch(currentUserProvider);
    await chatRepository.setChatMessageSeen(
      messageId: messageId,
      receiverUserId: receiverUserId,
      senderUserId: user.uid!,
    );
    return true;
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
