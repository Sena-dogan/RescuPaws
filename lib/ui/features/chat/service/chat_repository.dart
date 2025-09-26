import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rescupaws/constants/string_constants.dart';
import 'package:rescupaws/data/enums/message_type.dart';
import 'package:rescupaws/models/chat/chat_model.dart';
import 'package:rescupaws/models/chat/chat_ui_model.dart';
import 'package:rescupaws/models/chat/message.dart';
import 'package:rescupaws/models/user_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'chat_repository.g.dart';

@riverpod
class ChatRepository extends _$ChatRepository {
  @override
  ChatUiModel build() {
    return ChatUiModel();
  }

  /// add receiver user to firestore (users collection)
  /// control if user already exists in firestore dont add again
  Future<void> addReceiverUserToFirestore({
    required UserData receiverUser,
  }) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance
            .collection(StringsConsts.usersCollection)
            .doc(receiverUser.uid)
            .get();

    if (!userDoc.exists) {
      await _upsertUserDataToUsersCollection(receiverUser: receiverUser);
    }
  }

  Future<void> _upsertUserDataToUsersCollection({
    required UserData receiverUser,
  }) async {
    // saving user to firestore users collection (merge)
    await FirebaseFirestore.instance
        .collection(StringsConsts.usersCollection)
        .doc(receiverUser.uid)
        .set(
          <String, dynamic>{
            'uid': receiverUser.uid,
            'email': receiverUser.email,
            'displayName': receiverUser.displayName,
            'phoneNumber': receiverUser.phoneNumber,
            'photoUrl': receiverUser.photoUrl,
          }..removeWhere((String key, dynamic value) => value == null),
          SetOptions(merge: true),
        );
  }

  /// invoke to get user data by id
  Future<UserData?> getUserDataById(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance
            .collection(StringsConsts.usersCollection)
            .doc(userId)
            .get();

    if (userDoc.exists) {
      return UserData.fromJson(userDoc.data()!);
    } else {
      return null;
    }
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
        List<MessageModel> messagesList = <MessageModel>[];
        for (QueryDocumentSnapshot<Map<String, dynamic>> messageMap
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
        List<Chat> chatsList = <Chat>[];
        for (QueryDocumentSnapshot<Map<String, dynamic>> chatMap
            in chatsMap.docs) {
          chatsList.add(Chat.fromJson(chatMap.data()));
        }
        return chatsList;
      },
    );
  }

  /// invoke to send text message.
  Future<void> sendTextMessage({
    required String lastMessage,
    required String receiverUserId,
    required UserData senderUser,
    required UserData? receiverUser,
  }) async {
    if (receiverUser == null) {
      throw Exception('Alıcı kullanıcı bulunamadı');
    }

    DateTime time = DateTime.now();
    String messageId = const Uuid().v1();

    await _saveChatDataToUsersSubCollection(
      senderUser: senderUser,
      receiverUser: receiverUser,
      lastMessage: lastMessage,
      time: time,
    ).catchError((Object error) {
      throw Exception(error.toString());
    });

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
    Chat senderChat = Chat(
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
    Chat receiverChat = Chat(
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
    MessageModel messageModel = MessageModel(
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
