import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../constants/string_constants.dart';
import '../../../../data/enums/message_type.dart';
import '../../../../models/chat/chat_model.dart';
import '../../../../models/chat/chat_ui_model.dart';
import '../../../../models/chat/message.dart';
import '../../../../models/user_data.dart';

part 'chat_repository.g.dart';

@riverpod
class ChatRepository extends _$ChatRepository {
  @override
  ChatUiModel build() {
    return ChatUiModel();
  }

  /// invoke to get single chat (messages)
  Stream<List<MessageModel>> getMessagesList({
    required String senderUserId,
    required String receiverUserId,
  }) {
    return FirebaseFirestore.instance
        .collection(StringsConsts.usersCollection)
        .doc(senderUserId)
        .collection(StringsConsts.chatsCollection)
        .doc(receiverUserId)
        .collection(StringsConsts.messagesCollection)
        .orderBy('time')
        .snapshots()
        .map(
      (QuerySnapshot<Map<String, dynamic>> messagesMap) {
        final List<MessageModel> messagesList = <MessageModel>[];
        for (final QueryDocumentSnapshot<Map<String, dynamic>> messageMap
            in messagesMap.docs) {
          messagesList.add(MessageModel.fromJson(messageMap.data()));
        }
        return messagesList;
      },
    );
  }

  /// invoke to get all chats
  Stream<List<Chat>> getChatsList({
    required String senderUserId,
  }) {
    return FirebaseFirestore.instance
        .collection(StringsConsts.usersCollection)
        .doc(senderUserId)
        .collection(StringsConsts.chatsCollection)
        .snapshots()
        .map(
      (QuerySnapshot<Map<String, dynamic>> chatsMap) {
        final List<Chat> chatsList = <Chat>[];
        for (final QueryDocumentSnapshot<Map<String, dynamic>> chatMap
            in chatsMap.docs) {
          chatsList.add(Chat.fromJson(chatMap.data()));
        }
        return chatsList;
      },
    );
  }

  /// invoke to send text message.
  Future<void> sendTextMessage(
    {
    required String lastMessage,
    required String receiverUserId,
    required UserData senderUser,
    required UserData? receiverUser,
  }) async {
    final DateTime time = DateTime.now();
    final String messageId = const Uuid().v1();

    if (receiverUser == null) {
      throw Exception('Alıcı kullanıcı bulunamadı');
    }

    // saving chat data to chats sub-collection.
    await _saveChatDataToUsersSubCollection(
      senderUser: senderUser,
      receiverUser: receiverUser,
      lastMessage: lastMessage,
      time: time,
    ).catchError((Object error) {
      throw Exception(error.toString());
    });

    // saving message data to message sub collection.
    await _saveMessageDataToMessagesSubCollection(
      receiverUserId: receiverUserId,
      senderUserId: senderUser.uid ?? 'sender uid is null',
      messageId: messageId,
      senderUsername: senderUser.displayName ?? 'sender name is null',
      receiverUsername: receiverUser.displayName ?? 'receiver name is null',
      lastMessage: lastMessage,
      time: time,
      messageType: MessageType.text,
    ).catchError((Object error) {
      throw Exception(error.toString());
    });
  }

  /// Invoke to save chat data to users sub collections
  Future<void> _saveChatDataToUsersSubCollection({
    required UserData senderUser,
    required UserData receiverUser,
    required String lastMessage,
    required DateTime time,
  }) async {
    // sender chat
    final Chat senderChat = Chat(
      name: receiverUser.displayName ?? 'receiver name is null',
      profilePic: receiverUser.photoUrl ?? 'receiver photo url is null',
      userId: receiverUser.uid ?? 'receiver uid is null',
      time: time,
      message: lastMessage,
    );
    // saving chat to firestore
    await FirebaseFirestore.instance
        .collection(StringsConsts.usersCollection)
        .doc(senderUser.uid)
        .collection(StringsConsts.chatsCollection)
        .doc(receiverUser.uid)
        .set(senderChat.toJson());

    // receiver chat
    final Chat receiverChat = Chat(
      name: senderUser.displayName ?? 'sender name is null',
      profilePic: senderUser.photoUrl ?? 'sender photo url is null',
      userId: senderUser.uid ?? 'sender uid is null',
      time: time,
      message: lastMessage,
    );
    // saving chat to firestore
    await FirebaseFirestore.instance
        .collection(StringsConsts.usersCollection)
        .doc(receiverUser.uid)
        .collection(StringsConsts.chatsCollection)
        .doc(senderUser.uid)
        .set(receiverChat.toJson());
  }

  /// invoke to save message data to message sub collection
  Future<void> _saveMessageDataToMessagesSubCollection({
    required String receiverUserId,
    required String senderUserId,
    required String messageId,
    required String senderUsername,
    required String? receiverUsername,
    required String lastMessage,
    required DateTime time,
    required MessageType messageType,
  }) async {
    final MessageModel messageModel = MessageModel(
      senderID: senderUserId,
      receiverID: receiverUserId,
      messageID: messageId,
      isSeen: false,
      lastMessage: lastMessage,
      messageType: messageType,
      time: time,
    );

    // saving message data for sender
    await FirebaseFirestore.instance
        .collection(StringsConsts.usersCollection)
        .doc(senderUserId)
        .collection(StringsConsts.chatsCollection)
        .doc(receiverUserId)
        .collection(StringsConsts.messagesCollection)
        .doc(messageId)
        .set(messageModel.toJson());

    // saving message data for receiver
    await FirebaseFirestore.instance
        .collection(StringsConsts.usersCollection)
        .doc(receiverUserId)
        .collection(StringsConsts.chatsCollection)
        .doc(senderUserId)
        .collection(StringsConsts.messagesCollection)
        .doc(messageId)
        .set(messageModel.toJson());
  }

  Future<void> setChatMessageSeen({
    required String receiverUserId,
    required String senderUserId,
    required String messageId,
  }) async {
    // updating seen message to sender user doc
    await FirebaseFirestore.instance
        .collection(StringsConsts.usersCollection)
        .doc(senderUserId)
        .collection(StringsConsts.chatsCollection)
        .doc(receiverUserId)
        .collection(StringsConsts.messagesCollection)
        .doc(messageId)
        .update(<Object, Object?>{'isSeen': true});

    // updating seen message to receiver user doc
    await FirebaseFirestore.instance
        .collection(StringsConsts.usersCollection)
        .doc(receiverUserId)
        .collection(StringsConsts.chatsCollection)
        .doc(senderUserId)
        .collection(StringsConsts.messagesCollection)
        .doc(messageId)
        .update(<Object, Object?>{'isSeen': true});
  }
}
