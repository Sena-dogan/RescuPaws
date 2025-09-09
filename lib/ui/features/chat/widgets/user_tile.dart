import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/context_extensions.dart';

class UserTile extends ConsumerWidget {
  const UserTile({
    super.key,
    required this.text,
    this.onTap,
    required this.user,
  });
  final String text;
  final void Function()? onTap;
  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.person,
              color: context.colorScheme.onSecondary,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
