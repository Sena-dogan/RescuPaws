import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/router/app_router.dart';
import '../../../constants/assets.dart';
import '../../../utils/context_extensions.dart';
import '../../widgets/app_bar_gone.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../auth/login_logic.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const BottomNavBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Gap(20),
                ListTile(
                  trailing: Container(
                    width: 60,
                    height: 60,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: FirebaseAuth.instance.currentUser?.photoURL !=
                                null
                            ? NetworkImage(
                                FirebaseAuth.instance.currentUser!.photoURL!)
                            : Image.asset(Assets.PawPaw).image,
                        fit: BoxFit.fill,
                      ),
                      shape: const OvalBorder(),
                    ),
                  ),
                  title: Text(
                    FirebaseAuth.instance.currentUser?.displayName ??
                        'Kullanici',
                    style: context.textTheme.labelMedium,
                  ),
                  subtitle: Text(
                      FirebaseAuth.instance.currentUser?.email ?? '',
                      style: context.textTheme.labelSmall),
                ),
                // Invite friends button outlined with a border transtiion and with a leading icon
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share),
                    label: Text(
                      'Davet Et',
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
                        const String url = 'mailto:developer@patipati.app';
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
                            'https://patipati.app/privacy-policy.php';
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
                        const String url =
                            'https://patipati.app/user-terms.php';
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
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Çıkış Yap'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
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
