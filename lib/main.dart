// ignore_for_file: always_put_control_body_on_new_line

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'constants/strings.dart';
import 'data/hive/hive.dart';
import 'di/components/service_locator.dart';
import 'firebase_options.dart';
import 'my_app.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  debugPrint('Handling a background message: ${message.messageId}');
}


/// Try using const constructors as much as possible!

void main() async {
  /// Initialize packages
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await GetStorage.init();
  await initHive();
  await configureDependencies();
  await setPreferredOrientations();

  await Firebase.initializeApp(
    name: 'PatiPatiApp',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kReleaseMode)
  {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  final FirebaseMessaging messaging = FirebaseMessaging.instance;

final NotificationSettings settings = await messaging.requestPermission(
  
);

debugPrint('User granted permission: ${settings.authorizationStatus}');


FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  debugPrint('Got a message whilst in the foreground!');
  debugPrint('Message data: ${message.data}');

  if (message.notification != null) {
    debugPrint('Message also contained a notification: ${message.notification}');
  }
});

await FirebaseMessaging.instance.subscribeToTopic('all');

  //getIt<HiveHelper>().initHive();
  if (!kIsWeb) {
    if (Platform.isAndroid) {
      await FlutterDisplayMode.setHighRefreshRate();
    }
  }

  runApp(
    EasyLocalization(
      supportedLocales: const <Locale>[
        /// Add your supported locales here
        Locale('en'),
        Locale('tr'),
      ],
      path: Strings.localizationsPath,
      fallbackLocale: const Locale('en', ''),
      child: const ProviderScope(
        child: MyApp(),
      ),
    ),
  );

  /// Add this line to get the error stack trace in release mode
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
}
