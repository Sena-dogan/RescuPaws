import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/router/app_router.dart';
import '../../../config/theme/theme_logic.dart';
import '../../../constants/assets.dart';
import '../../../utils/context_extensions.dart';
import '../../../utils/pop_up.dart';
import '../../widgets/add_nav_button.dart';
import '../../widgets/app_bar_gone.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../auth/login_logic.dart';
import 'user_logic.dart';
import 'user_ui_model.dart';

/*
  This is the profile screen that is shown when the user is logged in.
  It contains the user's profile picture, name, email and some buttons
  to invite friends, help and support, security and privacy, etc.
*/
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserUiModel userLogic = ref.watch(userLogicProvider);
    return Container(
      height: context.height,
      width: context.width,
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        image: const DecorationImage(
          image: AssetImage(Assets.LoginBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: const EmptyAppBar(),
        floatingActionButton: const AddNavButton(),
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const BottomNavBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Gap(20),
                ListTile(
                  trailing: Stack(
                    children: <Widget>[
                      // Edit icon
                      InkWell(
                        onTap: () {
                          final bool resp = ref
                              .read(userLogicProvider.notifier)
                              .updateUserImage();
                          if (resp == false) {
                            context.showErrorSnackBar(
                                title: 'Hata',
                                message: 'Resim yüklenirken bir hata oluştu.');
                          }
                        },
                        child: userLogic.isImageLoading
                            ? const SizedBox(
                                width: 40,
                                height: 40,
                                child: CupertinoActivityIndicator(),
                              )
                            : Stack(
                                children: <Widget>[
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        image: FirebaseAuth.instance.currentUser
                                                    ?.photoURL !=
                                                null
                                            ? Image.network(
                                                FirebaseAuth.instance
                                                    .currentUser!.photoURL!,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object error,
                                                    StackTrace? stackTrace) {
                                                  debugPrint(
                                                      'AAAAAAAAAAAAAAAAAAAAA');
                                                  return Image.network(
                                                      //TODO: Add an placeholder image to Assets
                                                      'https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg');
                                                },
                                              ).image
                                            : Image.network(
                                                    'https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg')
                                                .image,
                                        fit: BoxFit.cover,
                                      ),
                                      shape: const OvalBorder(),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: context.colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                  title: Text(
                    userLogic.user?.displayName ?? 'Kullanici',
                    style: context.textTheme.labelMedium,
                  ),
                  subtitle: Text(userLogic.user?.email ?? '',
                      style: context.textTheme.bodyMedium),
                ),
                // Invite friends button outlined with a border transtiion and with a leading icon
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final InAppReview inAppReview = InAppReview.instance;

                      if (await inAppReview.isAvailable()) {
                        await inAppReview.openStoreListing();
                      }
                    },
                    icon: const Icon(Icons.star_outlined),
                    label: Text(
                      'Değerlendir',
                      style: context.textTheme.bodyMedium,
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const Gap(20),
                // Security section with full widht  and with a leading icon
                // Help and support section with full widht  and with a leading icon
                // Instead of share button, it is like a section that takes all the width
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Cihaz',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(
                      indent: 8,
                    ),
                    const Gap(10),
                    ListTile(
                      leading: const Icon(Icons.lightbulb_outline),
                      title: const Text('Tema'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        await showAdaptiveDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: AlertDialog(
                                  backgroundColor: context.colorScheme.surface,
                                  title: const Text(
                                    'Tema',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: const Icon(Icons.light_mode),
                                        title: const Text('Açık Tema'),
                                        onTap: () {
                                          ref
                                              .read(themeLogicProvider.notifier)
                                              .setThemeMode(ThemeMode.light);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.dark_mode),
                                        title: const Text('Koyu Tema'),
                                        onTap: () {
                                          ref
                                              .read(themeLogicProvider.notifier)
                                              .setThemeMode(ThemeMode.dark);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.lightbulb),
                                        title: const Text('Sistem Teması'),
                                        onTap: () {
                                          ref
                                              .read(themeLogicProvider.notifier)
                                              .setThemeMode(ThemeMode.system);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                    const Gap(10),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Yardım ve Destek',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(
                      indent: 8,
                    ),
                    const Gap(10),
                    // ListTile(
                    //   leading: Icon(Icons.help),
                    //   title: Text('Sıkça Sorulan Sorular'),
                    //   trailing: Icon(Icons.arrow_forward_ios),
                    // ),
                    ListTile(
                      leading: const Icon(Ionicons.call),
                      title: const Text('İletişim'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        const String url = 'mailto:help@patipati.app';
                        final Uri uri = Uri.parse(url);
                        await launchUrl(uri).catchError((Object? err) =>
                            // ignore: invalid_return_type_for_catch_error
                            debugPrint(err.toString()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Ionicons.reader_outline),
                      title: const Text('Gizlilik Politikası'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        const String url =
                            'https://patipati.app/privacy-policy';
                        final Uri uri = Uri.parse(url);
                        await launchUrl(uri).catchError((Object? err) =>
                            // ignore: invalid_return_type_for_catch_error
                            debugPrint(err.toString()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Ionicons.ticket_outline),
                      title: const Text('Kullanım Koşulları'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        const String url = 'https://patipati.app/user-terms';
                        final Uri uri = Uri.parse(url);
                        await launchUrl(uri).catchError((Object? err) =>
                            // ignore: invalid_return_type_for_catch_error
                            debugPrint(err.toString()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Ionicons.remove_circle_outline),
                      title: const Text('Hesabımı Sil'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        await popUp(
                          context,
                          title: 'Hesabınızı silmek istediğinize emin misiniz?',
                          buttonTitle: 'Sil',
                          onPressed: () async {
                            await ref
                                .read(loginLogicProvider.notifier)
                                .removeUser()
                                .then((bool value) => value
                                    ? context.go(SGRoute.login.route)
                                    : null)
                                .catchError((Object? err) =>
                                    // ignore: invalid_return_type_for_catch_error
                                    debugPrint(err.toString()));
                          },
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Çıkış Yap'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        await popUp(
                          context,
                          title:
                              'Hesabınızdan çıkış yapmak istediğinize emin misiniz?',
                          buttonTitle: 'Çıkış Yap',
                          onPressed: () async {
                            await ref
                                .read(loginLogicProvider.notifier)
                                .signOut()
                                .then((bool value) => value
                                    ? context.go(SGRoute.login.route)
                                    : null)
                                .catchError((Object? err) =>
                                    // ignore: invalid_return_type_for_catch_error
                                    debugPrint(err.toString()));
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
