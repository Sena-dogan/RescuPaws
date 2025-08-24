import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/assets.dart';
import '../../../../models/chat/message.dart';
import '../../../../utils/context_extensions.dart';
import '../../../home/widgets/loading_paw_widget.dart';
import '../../detail/widgets/advertiser_info.dart';
import '../logic/chat_logic.dart';
import '../widgets/message_item.dart';
import '../widgets/user_input.dart';

class MessageScreen extends ConsumerWidget {
  MessageScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverProfilePic,
  });
  final String receiverId;
  final String? receiverName;
  final String? receiverProfilePic;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);

    final AsyncValue<List<MessageModel>> messagesStream =
        ref.watch(getMessagesListProvider(receiverId));

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        image: const DecorationImage(
          image: AssetImage(Assets.HomeBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: SizedBox(
            width: size.width * 0.5,
            child: AdvertiserInfo(
              receiverName: receiverName,
              receiverProfilePic: receiverProfilePic,
              imageSize: size.width * 0.1,
              textStyle: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Divider(
              color: context.colorScheme.tertiary.withOpacity(0.15),
            ),
            // display messages
            Expanded(
              child: switch (messagesStream) {
                AsyncValue<Object>(:final Object error?) =>
                  Text('Error: $error'),
                AsyncValue<List<MessageModel>>(
                  :final List<MessageModel> valueOrNull?
                ) =>
                  valueOrNull != null
                      ? ListView.builder(
                          itemCount: valueOrNull.length,
                          itemBuilder: (BuildContext context, int index) {
                            return MessageItem(
                              auth: _auth,
                              message: valueOrNull[index],
                            );
                          },
                        )
                      : const Center(child: Text('No messages')),
                _ => const Center(child: LoadingPawWidget()),
              },
            ),
            // user input
            UserInput(
              onSendMessage: (String message) async {
                await ref.read(chatLogicProvider.notifier).sendTextMessage(
                      lastMessage: message,
                      receiverUserId: receiverId,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
