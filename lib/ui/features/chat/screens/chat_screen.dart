import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_router.dart';
import '../../../../constants/assets.dart';
import '../../../../constants/string_constants.dart';
import '../../../../utils/context_extensions.dart';
import '../../../home/widgets/loading_paw_widget.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../models/chat_model.dart';
import '../service/chat_service.dart';
import '../widgets/user_tile.dart';

class ChatScreen extends ConsumerWidget {
  ChatScreen({super.key});

  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<Chat>>(
      stream: ref.watch(chatControllerProvider).getChatsList(),
      builder: (BuildContext context, AsyncSnapshot<List<Chat>> snapshot) {
        if (!snapshot.hasData) {
          return const Loader();
        }
        return snapshot.data!.isEmpty
            ? const NoChat()
            : ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  final Chat chat = snapshot.data![index];
                  return _buildChatListItem(context, index, chat);
                },
              );
      },
    );
  }

  Widget _buildChatListItem(BuildContext context, int index, Chat chat) {
    final Size size = MediaQuery.of(context).size;

    return ListTile(
      onTap: () => Navigator.pushNamed(
        context,
        SGRoute.conversation.route,
        arguments: <String, Object>{
          StringsConsts.username: chat.name,
          StringsConsts.userId: chat.userId,
          StringsConsts.profilePic: chat.profilePic,
          StringsConsts.isGroupChat: false,
        },
      ),
      title: Text(
        chat.name,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: size.width * 0.045,
            ),
      ),
      subtitle: Text(
        chat.lastMessage,
        maxLines: 1,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: size.width * 0.035,
            ),
      ),
      leading: CircleAvatar(
        radius: 30.0,
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
