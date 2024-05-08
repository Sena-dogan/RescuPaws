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
    return StreamBuilder<Set<String>>(
      stream: _chatService.getMessagedUsersStream(),
      builder: (BuildContext context, AsyncSnapshot<Set<String>> snapshot) {
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
              final String receiverId = snapshot.data!.elementAt(index);
              // Here you can build your UI for each messaged user.
              // For example, you might want to display the receiver's name or profile picture.
              return ListTile(
                title: Text('User ID: $receiverId'),
                // Add more UI elements as needed
              );
            },
          );
        }

        return const Text('No messaged users found');
      },
    );
  }
}
