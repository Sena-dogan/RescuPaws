import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConversationScreen extends ConsumerWidget {
  const ConversationScreen({
    super.key,
    required this.receiverEmail,
  });
  final String receiverEmail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
      ),
      body: const Center(
        child: Text('Conversation Screen'),
      ),
    );
  }
}
