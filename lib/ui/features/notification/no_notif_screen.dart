import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../config/router/app_router.dart';
import '../../../constants/assets.dart';
import '../../../utils/context_extensions.dart';

class NoNotifScreen extends ConsumerWidget {
  const NoNotifScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        image: const DecorationImage(
          image: AssetImage(Assets.HomeBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
              color: context.colorScheme.scrim,
            ),
            onPressed: () => context.go(SGRoute.home.route),
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'No Notifications...',
                  style: context.textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Lottie.asset(
              Assets.NoNotif,
              height: size.height * 0.5,
            ),
          ],
        ),
      ),
    );
  }
}
