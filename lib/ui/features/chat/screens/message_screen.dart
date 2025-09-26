import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rescupaws/models/chat/message.dart';
import 'package:rescupaws/ui/features/chat/logic/chat_logic.dart';
import 'package:rescupaws/ui/features/chat/widgets/message_item.dart';
import 'package:rescupaws/ui/features/chat/widgets/user_input.dart';
import 'package:rescupaws/ui/features/detail/widgets/advertiser_info.dart';
import 'package:rescupaws/ui/home/widgets/loading_paw_widget.dart';
import 'package:rescupaws/utils/context_extensions.dart';

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
    Size size = MediaQuery.sizeOf(context);

    AsyncValue<List<MessageModel>> messagesStream =
        ref.watch(getMessagesListProvider(receiverId));

    return DecoratedBox(
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
              color: context.colorScheme.tertiary.withValues(alpha:0.15),
            ),
            // display messages
            Expanded(
              child: switch (messagesStream) {
                AsyncValue<Object>(:Object error?) =>
                  Text('Error: $error'),
                AsyncValue<List<MessageModel>>(
                  :List<MessageModel> value?
                ) =>
                  ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (BuildContext context, int index) {
                            return MessageItem(
                              auth: _auth,
                              message: value[index],
                            );
                          },
                        ),
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
