import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:rescupaws/models/chat/message.dart';
import 'package:rescupaws/ui/features/chat/widgets/chat_bubble.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    super.key,
    required this.auth,
    required this.message,
  });
  final FirebaseAuth auth;
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    // handle current user is null or not
    if (auth.currentUser == null) {
      return const Text('Current user is null');
    }
    bool isCurrentUser = message.senderID == auth.currentUser!.uid;
    Alignment alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          ChatBubble(
            message: message,
            isCurrentUser: isCurrentUser,
          ),
        ],
      ),
    );
  }
}
