import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:rescupaws/models/chat/chat_model.dart';
import 'package:rescupaws/ui/features/chat/logic/chat_logic.dart';
import 'package:rescupaws/ui/features/chat/widgets/chat_list_item.dart';
import 'package:rescupaws/ui/widgets/bottom_nav_bar.dart';
import 'package:rescupaws/utils/context_extensions.dart';
import 'package:rescupaws/utils/error_widgett.dart';

class ChatsScreen extends ConsumerWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
         gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            context.colorScheme.surface,
            context.colorScheme.primaryContainer,
          ],
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
              Logger().e('Error: ${snapshot.error}');
              return PawErrorWidget(onRefresh: () async {
                // ignore: unused_result
                ref.refresh(chatLogicProvider);
              });
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  Chat chat = snapshot.data![index];
                  return ChatListItem(chat: chat);
                },
              );
            }

            return const Text('No messaged users found');
          },
        ),
      ),
    );
  }
}
