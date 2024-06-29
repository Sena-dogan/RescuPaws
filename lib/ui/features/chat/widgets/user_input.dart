import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/context_extensions.dart';

class UserInput extends ConsumerStatefulWidget {
  const UserInput({
    super.key,
    required this.onSendMessage,
  });

  final Function(String) onSendMessage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserInputState();
}

class _UserInputState extends ConsumerState<UserInput> {
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
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
                final String message = _messageController.text;
                _messageController.clear();
                if (message.isNotEmpty) {
                  widget.onSendMessage(message);
                } else {
                  // show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen bir mesaj yazın'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
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
