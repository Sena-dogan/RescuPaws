import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rescupaws/models/chat/chat_model.dart';
import 'package:rescupaws/ui/features/chat/screens/message_screen.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({super.key, required this.chat});
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          //TODO: Change to go route
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              debugPrint('Chat User ID: ${chat.userId} (ChatsScreen)');
              return MessageScreen(
                receiverId: chat.userId,
                receiverName: chat.name,
                receiverProfilePic: chat.profilePic,
              );
                        },
          ),
        );
      },
      title: Text(
        chat.name,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: size.width * 0.045,
            ),
      ),
      subtitle: Text(
        chat.message,
        maxLines: 1,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: size.width * 0.035,
            ),
      ),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(
          chat.profilePic,
        ),
      ),
      trailing: Text(
        DateFormat.Hm().format(chat.time),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: size.width * 0.030,
            ),
      ),
    );
  }
}
