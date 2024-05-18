import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
Stream<List<MessageModel>> getMessagesList(
    GetMessagesListRef ref, String receiverUserId) {
  debugPrint('Receiver user id is $receiverUserId');
  final ChatRepository chatRepository =
      ref.read(chatRepositoryProvider.notifier);
  debugPrint('Chat repository is $chatRepository');
  final UserData senderUser = ref.read(currentUserProvider);
  debugPrint('Sender user is $senderUser');
  return chatRepository.getMessagesList(
    senderUserId: senderUser.uid!,
    receiverUserId: receiverUserId,
  );
 
  // final socket = await Socket.connect('my-api', 4242);
  // ref.onDispose(socket.close);

  // var allMessages = const <String>[];
  // await for (final message in socket.map(utf8.decode)) {
  //   // A new message has been received. Let's add it to the list of all messages.
  //   allMessages = [...allMessages, message];
  //   yield allMessages;
  // }
}

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
        ref.read(chatRepositoryProvider.notifier);
    
    final UserData? receiverUser = state.user;

    await chatRepository
        .sendTextMessage(
      lastMessage: lastMessage,
      receiverUserId: receiverUserId,
      senderUser: ref.read(currentUserProvider),
      receiverUser: receiverUser,
    )
        .catchError((Object error) {
          Logger().e(error);
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

  // // get messages list function
  // Stream<MessageModel> getMessagesList(String receiverUserId) async* {
  //   final ChatRepository chatRepository =
  //       ref.read(chatRepositoryProvider.notifier);
  //   final UserData senderUser = ref.read(currentUserProvider);
  //   final Stream<QuerySnapshot<Map<String, dynamic>>> snapshot =
  //       chatRepository.getMessagesList(
  //     senderUserId: senderUser.uid!,
  //     receiverUserId: receiverUserId,
  //   );

  //   snapshot.map((QuerySnapshot<Map<String, dynamic>> event) {
  //     if (event.docs.isEmpty) {
  //       debugPrint('No messages found');
  //       return null;
  //     }
  //     return event.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) async* {
  //         final Map<String, dynamic> data = e.data();
  //         yield MessageModel.fromJson(data);
  //       });

  //   });
  // }

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
