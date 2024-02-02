import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/assets.dart';
import '../../../utils/context_extensions.dart';

class VaccineScreen extends ConsumerWidget {
  const VaccineScreen({super.key});

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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 30,
                color: context.colorScheme.scrim,
              ),
              onPressed: () {
                context.pop();
              },
            ),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              'Aşılar',
              style: context.textTheme.labelSmall,
            ),
          ),
        ));
  }
}
