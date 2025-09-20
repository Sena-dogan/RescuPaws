import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rescupaws/data/network/user/user_repository.dart';
import 'package:rescupaws/models/chat/chat_model.dart';
import 'package:rescupaws/models/chat/chat_ui_model.dart';
import 'package:rescupaws/models/chat/message.dart';
import 'package:rescupaws/models/user_data.dart';
import 'package:rescupaws/ui/features/chat/service/chat_repository.dart';
import 'package:rescupaws/ui/features/detail/logic/detail_logic.dart';
import 'package:rescupaws/utils/riverpod_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_logic.g.dart';

/// Fetch a user profile from Firestore 'users/{userId}'
@riverpod
Future<UserData?> getUserById(Ref ref, String userId) async {
  ChatRepository chatRepository = ref.read(
    chatRepositoryProvider.notifier,
  );
  return chatRepository.getUserDataById(userId);
}

@riverpod
Stream<List<MessageModel>> getMessagesList(Ref ref, String receiverUserId) {
  debugPrint('Receiver user id is $receiverUserId');
  ChatRepository chatRepository = ref.read(
    chatRepositoryProvider.notifier,
  );
  debugPrint('Chat repository is $chatRepository');
  UserData senderUser = ref.read(currentUserProvider);
  debugPrint('Sender user is $senderUser');
  return chatRepository.getMessagesList(
    senderUserId: senderUser.uid!,
    receiverUserId: receiverUserId,
  );
}

@riverpod
class ChatLogic extends _$ChatLogic {
  @override
  ChatUiModel build() {
    ref.cacheFor(const Duration(hours: 1));
    UserData? user = ref.watch(detailLogicProvider).user;
    return ChatUiModel(user: user);
  }

  // add receiver user to firestore function
  Future<bool> addReceiverUserToFirestore({
    required UserData receiverUser,
  }) async {
    ChatRepository chatRepository = ref.read(
      chatRepositoryProvider.notifier,
    );
    try {
      await chatRepository.addReceiverUserToFirestore(
        receiverUser: receiverUser,
      );
      debugPrint('Receiver user added to Firestore successfully');
    } catch (error) {
      Logger().e('Error in addReceiverUserToFirestore: $error');
      setError(error.toString());
      return false;
    }
    return true;
  }

  // Send text message function
  Future<bool> sendTextMessage({
    required String lastMessage,
    required String receiverUserId,
  }) async {
    ChatRepository chatRepository = ref.read(
      chatRepositoryProvider.notifier,
    );
    UserData senderUser = ref.read(currentUserProvider);

    // Alıcı kullanıcı bilgisini Firestore'dan alma
    debugPrint('Getting receiver user data for ID: $receiverUserId');
    UserData? receiverUser = await getUserDataById(receiverUserId);

    if (receiverUser == null) {
      debugPrint('Receiver user not found for ID: $receiverUserId');
      throw Exception('Alıcı kullanıcı bulunamadı');
    }

    debugPrint('Receiver user found: ${receiverUser.displayName}');

    try {
      await chatRepository.sendTextMessage(
        lastMessage: lastMessage,
        receiverUserId: receiverUserId,
        senderUser: senderUser,
        receiverUser: receiverUser,
      );
      debugPrint('Message sent successfully');
    } catch (error) {
      Logger().e('Error in sendTextMessage: $error');
      setError(error.toString());
      return false;
    }
    return true;
  }

  // get user data by id function
  Future<UserData?> getUserDataById(String userId) async {
    ChatRepository chatRepository = ref.read(
      chatRepositoryProvider.notifier,
    );
    return chatRepository.getUserDataById(userId);
  }

  // get chats list function
  Stream<List<Chat>> getChatsList() {
    ChatRepository chatRepository = ref.watch(
      chatRepositoryProvider.notifier,
    );
    UserData senderUser = ref.watch(currentUserProvider);
    return chatRepository.getChatsList(senderUserId: senderUser.uid!);
  }

  // set chat message seen function
  Future<bool> setChatMessageSeen({
    required String receiverUserId,
    required String messageId,
  }) async {
    ChatRepository chatRepository = ref.watch(
      chatRepositoryProvider.notifier,
    );
    UserData user = ref.watch(currentUserProvider);
    await chatRepository.setChatMessageSeen(
      messageId: messageId,
      receiverUserId: receiverUserId,
      senderUserId: user.uid!,
    );
    return true;
  }

  void setError(String errorMessage) =>
      state = state.copyWith(errorMessage: errorMessage, isLoading: false);

  void setDetailUser(UserData? user) {
    Logger().i('User is $user');
    state = state.copyWith(user: user);
  }
}
