import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/router/app_router.dart';
import '../../../../constants/assets.dart';
import '../../../../utils/context_extensions.dart';
import '../../../home/widgets/loading_paw_widget.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../service/chat_service.dart';
import '../widgets/user_tile.dart';

class ChatScreen extends ConsumerWidget {
  ChatScreen({super.key});

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
        body: _buildUserList(),
      ),
    );
  }

  StreamBuilder<List<Map<String, dynamic>>> _buildUserList() {
    // ignore: always_specify_types
    return StreamBuilder(
        stream: _chatService.getUsersStream(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Lottie.asset(
                Assets.Error,
                repeat: true,
                height: 200,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPawWidget();
          }
          return ListView(
            children: snapshot.data!
                .map<Widget>((Map<String, dynamic> userData) =>
                    _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    return UserTile(
      text: userData['email'] as String,
      onTap: () {
        context.push(SGRoute.conversation.route);
      },
    );
  }
}
