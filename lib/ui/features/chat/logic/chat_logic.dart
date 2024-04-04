import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_logic.g.dart';

@riverpod
class ChatController extends _$ChatController {
  ChatController(this.ref) : super(ref);

  final ProviderRef ref;

  @override
  Future<void> sendTextMessage(
    BuildContext context, {
    required String lastMessage,
    required String receiverUserId,
    required String? groupId,
    required bool isGroupChat,
  }) async {
    final chatRepository = ref.watch(chatRepositoryProvider);
    final replyMessage = ref.watch(replyMessageProvider);
    final senderUser = ref.watch(currentUserProvider!);

    await chatRepository.sendTextMessage(
      context,
      lastMessage: lastMessage,
      receiverUserId: receiverUserId,
      senderUser: senderUser,
      replyMessage: replyMessage,
      groupId: groupId,
      isGroupChat: isGroupChat,
    );

    ref.watch(replyMessageProvider.state).state = null;
  }

  // Similar adaptations for other methods...
}
