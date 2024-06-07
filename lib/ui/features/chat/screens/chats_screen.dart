import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/assets.dart';
import '../../../../models/chat/chat_model.dart';
import '../../../../utils/context_extensions.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../logic/chat_logic.dart';
import 'message_screen.dart';

class ChatsScreen extends ConsumerWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        image: const DecorationImage(
          image: AssetImage(Assets.LoginBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Mesajlar',
            style: context.textTheme.labelSmall,
          ),
        ),
        bottomNavigationBar: const PawBottomNavBar(),
        backgroundColor: Colors.transparent,
        body: StreamBuilder<List<Chat>>(
          stream: ref.watch(chatLogicProvider.notifier).getChatsList(),
          builder: (BuildContext context, AsyncSnapshot<List<Chat>> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  final Chat chat = snapshot.data![index];
                  return _buildChatListItem(context, index, chat);
                },
              );
            }

            return const Text('No messaged users found');
          },
        ),
      ),
    );
  }

  Widget _buildChatListItem(BuildContext context, int index, Chat chat) {
    final Size size = MediaQuery.of(context).size;

    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          // ignore: always_specify_types
          MaterialPageRoute(
            builder: (BuildContext context) {
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
