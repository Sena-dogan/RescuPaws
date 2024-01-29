import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/router/app_router.dart';
import '../../../constants/assets.dart';
import '../../../utils/context_extensions.dart';
import '../../widgets/app_bar_gone.dart';
import 'login_logic.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
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
        appBar: const EmptyAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(),
              Image.asset(
                Assets.PawPaw,
                filterQuality: FilterQuality.none,
                fit: BoxFit.none,
              ),
              Text(
                'Giriş Yap',
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.colorScheme.scrim,
                ),
              ),
              const Spacer(),
              _buildFooterButton(Size(size.width, size.height * 0.12)),
              const Gap(10),
            ],
          ),
        ),
      ),
    );
  }

  Align _buildFooterButton(Size size) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SocialLoginButton(
                  buttonType: SocialLoginButtonType.google,
                  text: 'Google ile giriş yap',
                  onPressed: () async {
                    await ref
                        .read(loginLogicProvider.notifier)
                        .signInWithGoogle()
                        .then((bool value) => value
                            ? context.go(SGRoute.home.route)
                            : context.showErrorSnackBar(
                                title: 'Hata',
                                message:
                                    'Bir hata oluştu. Lütfen tekrar deneyiniz.'));
                  },
                  borderRadius: 30),
            ),
            Visibility(
              visible: Platform.isIOS,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SocialLoginButton(
                    buttonType: SocialLoginButtonType.appleBlack,
                    text: 'Apple ile giriş yap',
                    onPressed: () {
                      ref
                          .read(loginLogicProvider.notifier)
                          .signInWithApple()
                          .then((bool value) => value
                              ? context.go(SGRoute.home.route)
                              : context.showErrorSnackBar(
                                  title: 'Hata',
                                  message:
                                      'Bir hata oluştu. Lütfen tekrar deneyiniz.'));
                    },
                    borderRadius: 30),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SocialLoginButton(
                  buttonType: SocialLoginButtonType.generalLogin,
                  text: 'E-posta ile giriş yap',
                  onPressed: () {
                    context.push(SGRoute.emailLogin.route);
                  },
                  backgroundColor: context.colorScheme.primary,
                  borderRadius: 30),
            ),
            _buildTermsOfService(),
            _buildPrivacyPolicy(),
          ],
        ),
      ),
    );
  }

  Padding _buildPrivacyPolicy() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'onaylamış olursunuz.',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: context.colorScheme.scrim,
            ),
          ),
          GestureDetector(
            onTap: () {
              const String url = 'https://patipati.app/privacy-policy';
              final Uri uri = Uri.parse(url);
              launchUrl(uri).catchError((Object? err) =>
                  // ignore: invalid_return_type_for_catch_error
                  debugPrint(err.toString()));
            },
            child: Text(
              'Gizlilik Politikamızı ',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
                color: context.colorScheme.scrim,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsOfService() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Oturum açarak ',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: context.colorScheme.scrim,
              ),
            ),
            InkWell(
              onTap: () async {
                const String url = 'https://patipati.app/user-terms';
                final Uri uri = Uri.parse(url);
                await launchUrl(uri).catchError((Object? err) =>
                    // ignore: invalid_return_type_for_catch_error
                    debugPrint(err.toString()));
              },
              child: Text(
                'Hizmet Koşullarımızı ',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                  color: context.colorScheme.scrim,
                ),
              ),
            ),
            Text('kabul etmiş ve ',
                style: GoogleFonts.outfit(
                    fontSize: 14, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
