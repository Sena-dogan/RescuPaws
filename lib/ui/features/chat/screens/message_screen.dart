import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/assets.dart';
import '../../../../models/chat/message.dart';
import '../../../../models/user_data.dart';
import '../../../../utils/context_extensions.dart';
import '../../detail/widgets/advertiser_info.dart';
import '../logic/chat_logic.dart';
import '../widgets/chat_bubble.dart';

class MessageScreen extends ConsumerWidget {
  MessageScreen({
    super.key,
    required this.receiverId,
  });
  final String receiverId;

  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final UserData? user = ref.watch(chatLogicProvider).user;

    final AsyncValue<List<MessageModel>> messagesStream =
        ref.watch(getMessagesListProvider(receiverId));

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.background,
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
                user: user,
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
                  // child: StreamBuilder<List<MessageModel>>(
                  //     stream: messagesStream,
                  //     builder: (BuildContext context,
                  //         AsyncSnapshot<List<MessageModel>> snapshot) {
                  //       if (snapshot.hasError) {
                  //         return Center(
                  //           child: Lottie.asset(
                  //             Assets.Error,
                  //             repeat: true,
                  //             height: 200,
                  //           ),
                  //         );
                  //       }

                  //       if (snapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return const LoadingPawWidget();
                  //       }

                  //       if (snapshot.hasData) {
                  //         debugPrint('Messages found');
                  //         final List<MessageModel> messages = snapshot.data!;
                  //         if (messages.isEmpty) {
                  //           debugPrint('No messages found');
                  //           return Center(
                  //             child: Lottie.asset(
                  //               Assets.Error,
                  //               repeat: true,
                  //               height: 200,
                  //             ),
                  //           );
                  //         }
                  //         return ListView.builder(
                  //           itemCount: messages.length,
                  //           reverse: true,
                  //           itemBuilder: (BuildContext context, int index) {
                  //             final MessageModel message = messages[index];
                  //             return _buildMessageItem(message);
                  //           },
                  //         );
                  //       }
                  //       return const Center(
                  //         child: CircularProgressIndicator(),
                  //       );
                  //     })),
                  child: switch (messagesStream) {
                // ignore: always_specify_types
                AsyncValue(:final Object error?) => Text('Error: $error'),
                // ignore: always_specify_types
                AsyncValue(:final List<MessageModel> valueOrNull?) =>
                  Text('$valueOrNull'),
                _ => const CircularProgressIndicator(),
              }),
              // user input
              _buildUserInput(
                context,
                onSendMessage: (String message) async {
                  await ref.read(chatLogicProvider.notifier).sendTextMessage(
                        lastMessage: _messageController.text,
                        receiverUserId: receiverId,
                      );
                },
              ), // send message button and text field
            ],
          )),
    );
  }

  // build messages list

  // build message item
  Widget _buildMessageItem(MessageModel message) {
    final bool isCurrentUser = message.senderID == _auth.currentUser!.uid;
    final Alignment alignment =
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

  // build user input
  Widget _buildUserInput(BuildContext context,
      {required Function(String) onSendMessage}) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        bottom: size.height * 0.05,
        left: size.width * 0.05,
        right: size.width * 0.05,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 55,
            width: size.width * 0.75,
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hoverColor: context.colorScheme.primary,
                border: _messageFieldBorder(context),
                enabledBorder: _messageFieldBorder(context),
                focusedBorder: _messageFieldBorder(context),
                hintText: 'Bir mesaj yazın...',
              ),
            ),
          ),
          Container(
            height: 40,
            width: 40,
            decoration: ShapeDecoration(
              color: context.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            margin: EdgeInsets.only(left: size.width * 0.05),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () {
                debugPrint('Message sent ${_messageController.text}');
                _messageController.clear();
                onSendMessage(_messageController.text);
              },
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _messageFieldBorder(BuildContext context) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: context.colorScheme.secondary,
        width: 0.7,
      ),
      borderRadius: BorderRadius.circular(20),
    );
  }
}
