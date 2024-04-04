import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../constants/string_constants.dart';
import '../models/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// invoke to get all chats
  Stream<List<Chat>> getChatsList({
    required String senderUserId,
  }) {
    return _firestore
        .collection(StringsConsts.usersCollection)
        .doc(senderUserId)
        .collection(StringsConsts.chatsCollection)
        .snapshots()
        .map(
      (QuerySnapshot<Map<String, dynamic>> chatsMap) {
        final List<Chat> chatsList = <Chat>[];
        for (final QueryDocumentSnapshot<Map<String, dynamic>> chatMap
            in chatsMap.docs) {
          chatsList.add(Chat.fromMap(chatMap.data()));
        }
        return chatsList;
      },
    );
  }
}
