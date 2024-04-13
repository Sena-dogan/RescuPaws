import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../../constants/assets.dart';
import '../../../../models/chat/message.dart';
import '../../../home/widgets/loading_paw_widget.dart';
import '../service/chat_service.dart';

class MessageScreen extends ConsumerWidget {
  MessageScreen({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
  });
  final String receiverEmail;
  final String receiverId;

  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();

  // send message
  Future<void> _sendMessage() async {
    final String message = _messageController.text;
    // if there is something inside the text field
    if (message.isNotEmpty) {
      // send the message
      await _chatService.sendMessage(receiverId, message);

      // clear the text field
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Message'),
        ),
        body: Column(
          children: <Widget>[
            // display messages
            Expanded(child: _buildMessagesList()),

            // user input
            _buildUserInput(),
          ],
        ));
  }

  // build messages list
  Widget _buildMessagesList() {
    return StreamBuilder<List<MessageModel>>(
        stream: _chatService.getMessages(receiverId),
        builder:
            (BuildContext context, AsyncSnapshot<List<MessageModel>> snapshot) {
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

          final List<MessageModel> messages = snapshot.data!;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              final MessageModel message = messages[index];
              return ListTile(
                title: Text(message.message),
                subtitle: Text(message.senderEmail),
              );
            },
          );
        });
  }

  // build user input
  Widget _buildUserInput() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: const InputDecoration(
              hintText: 'Type a message...',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: _sendMessage,
        ),
      ],
    );
  }
}
