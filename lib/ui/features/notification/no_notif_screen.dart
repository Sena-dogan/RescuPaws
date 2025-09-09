import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../constants/assets.dart';
import '../../../utils/context_extensions.dart';
import '../../../utils/error_widgett.dart';

part 'no_notif_screen.g.dart';

@riverpod
Future<List<RemoteMessage>> getMessages(Ref ref) async {
  final List<RemoteMessage> messages = <RemoteMessage>[];
  final RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    messages.add(initialMessage);
  }
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    messages.add(message);
  });
  return messages;
}

class NoNotifScreen extends ConsumerWidget {
  const NoNotifScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<RemoteMessage>> getMessagesAsyncValue =
        ref.watch(getMessagesProvider);
    return Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: getMessagesAsyncValue.when(
            data: (List<RemoteMessage> messages) {
              if (messages.isEmpty) {
                return const NoNotificationScreen();
              }
              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(messages[index].notification?.title ?? ''),
                    subtitle: Text(messages[index].notification?.body ?? ''),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (Object error, StackTrace stackTrace) => Center(
              child: PawErrorWidget(onRefresh: () async {
                // Optionally, you can use the result if needed:
                // await ref.refresh(getMessagesProvider.future);
              }),
            ),
          ),
        ));
  }
}

class NoNotificationScreen extends StatelessWidget {
  const NoNotificationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Align(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Henüz bildirim yok..',
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
    );
  }
}
