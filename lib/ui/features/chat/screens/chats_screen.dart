import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../../constants/assets.dart';
import '../../../../utils/context_extensions.dart';
import '../../../../utils/firebase_utils.dart';
import '../../../home/widgets/loading_paw_widget.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../service/chat_service.dart';
import '../widgets/user_tile.dart';
import 'message_screen.dart';

class ChatsScreen extends ConsumerWidget {
  ChatsScreen({super.key});

  final ChatService _chatService = ChatService();

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
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Mesajlar',
            style: context.textTheme.labelSmall,
          ),
        ),
        bottomNavigationBar: const BottomNavBar(),
        backgroundColor: Colors.transparent,
        body: _buildMessagedUserList(),
      ),
    );
  }

  /// Builds the list of users that have been messaged.
  ///  This method uses a [StreamBuilder] to listen for changes in the list of users.
  ///  Also this method uses [MessageModel] and [getMessagedUsers()] function from [ChatService].
  /// The [MessageModel] is used to represent a message and the [getMessagedUsers()] function is used to get the list of users that have been messaged.
  Widget _buildMessagedUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessagedUsers(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPawWidget();
        } else if (snapshot.hasError) {
          debugPrint('Error: ${snapshot.error}');
          return Center(
            child: Lottie.asset(
              Assets.Error,
              width: 200,
              height: 200,
            ),
          );
        } else {
          if (snapshot.data == null) {
            return const Center(
              child: Text('Henüz mesajlaştığınız bir kullanıcı yok. ero'),
            );
          }
          final List<String?> users =
              snapshot.data!.docs.map((QueryDocumentSnapshot<Object?> doc) {
            debugPrint('doc: $doc');
            return doc.id;
          }).toList();

          if (users.isEmpty) {
            return const Center(
              child: Text('Henüz mesajlaştığınız bir kullanıcı yok.'),
            );
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final String? receiverId = users[index];
              if (receiverId == null) {
                return const SizedBox();
              }
              return ListTile(
                title: Text(receiverId),
                onTap: () {},
              );
            },
          );
        }
      },
    );
  }
}
