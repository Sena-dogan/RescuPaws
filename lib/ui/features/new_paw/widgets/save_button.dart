import 'package:flutter/material.dart';

import '../../../../utils/context_extensions.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final void Function()? onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all<Color>(context.colorScheme.primary),
        fixedSize: WidgetStateProperty.all<Size>(
          Size(size.width, 50),
        ),
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
      child: Text(
        title,
        style: context.textTheme.labelSmall?.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
