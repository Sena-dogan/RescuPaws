import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/router/app_router.dart';
import '../../../constants/assets.dart';
import '../../../utils/context_extensions.dart';
import 'login_logic.dart';
import 'login_ui_model.dart';
import 'social_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final LoginUiModel loginModel = ref.watch(loginLogicProvider);
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
        appBar: AppBar(
          backgroundColor: context.colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            side: BorderSide(
              color: context.colorScheme.scrim.withOpacity(0.2),
            ),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Kayıt Ol',
                  style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.primary, fontSize: 16)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: size.width,
            height: size.height * 0.9,
            child: Column(
              children: <Widget>[
                Gap(size.height * 0.05),
                _loginText(context),
                const Gap(25),
                _buildLoginButtons(Size(size.width, size.height * 0.12)),
                const Gap(25),
                _buildOrDivider(size, context),
                const Gap(25),
                _emailText(context),
                const Gap(25),
                _buildEmail(size, context),
                const Gap(16),
                _buildPass(size, loginModel, context),
                const Gap(16),
                _buildTermsOfService(),
                _buildPrivacyPolicy(),
                const Gap(16),
                _buildSignInButton(context),
                _forgotPasswordButton(context),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text _emailText(BuildContext context) {
    return Text('E-posta ile devam edin', style: context.textTheme.labelSmall);
  }

  Text _loginText(BuildContext context) {
    return Text(
      'Giriş Yap',
      style: context.textTheme.labelSmall
          ?.copyWith(color: context.colorScheme.scrim),
    );
  }

  TextButton _forgotPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.go(SGRoute.forgotPassword.route);
      },
      child: Text(
        'Şifremi unuttum',
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.primary,
        ),
      ),
    );
  }

  SizedBox _buildSignInButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.9,
      height: 48,
      child: ElevatedButton(
        onPressed: () async {
          await ref
              .read(loginLogicProvider.notifier)
              .signInWithEmailAndPassword()
              .catchError((Object? err) {
            debugPrint(err.toString());
            context.showErrorSnackBar(
                message: 'Bir hata oluştu. Lütfen tekrar deneyiniz.');
            return false;
          }).then((bool value) => value
                  ? context.go(SGRoute.home.route)
                  : context.showErrorSnackBar(
                      message: 'Bir hata oluştu. Lütfen tekrar deneyiniz.'));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30),
        ),
        child: Text(
          'Giriş Yap',
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.colorScheme.background,
          ),
        ),
      ),
    );
  }

  SizedBox _buildPass(
      Size size, LoginUiModel loginModel, BuildContext context) {
    return SizedBox(
      width: size.width * 0.9,
      height: 50,
      child: TextFormField(
        controller: _passwordController,
        obscureText: loginModel.isObscure,
        onChanged: (String value) {
          ref.read(loginLogicProvider.notifier).passwordChanged(value);
        },
        autofillHints: const <String>[AutofillHints.password],
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        decoration: InputDecoration(
          hintText: 'Şifre',
          hintStyle: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.scrim,
          ),
          fillColor: context.colorScheme.background,
          filled: true,
          contentPadding: const EdgeInsets.all(15),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.colorScheme.primary),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.colorScheme.primary),
            borderRadius: BorderRadius.circular(16),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              ref.read(loginLogicProvider.notifier).toggleObscure();
            },
            icon: Icon(
              loginModel.isObscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: context.colorScheme.scrim.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildEmail(Size size, BuildContext context) {
    return SizedBox(
      width: size.width * 0.9,
      height: 50,
      child: TextFormField(
          controller: _emailController,
          onChanged: (String value) {
            ref.read(loginLogicProvider.notifier).emailChanged(value);
          },
          autofillHints: const <String>[AutofillHints.email],
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          decoration: InputDecoration(
            hintText: 'E-posta',
            hintStyle: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.scrim,
            ),
            fillColor: context.colorScheme.background,
            filled: true,
            contentPadding: const EdgeInsets.all(15),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: context.colorScheme.primary),
              borderRadius: BorderRadius.circular(16),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: context.colorScheme.primary),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: context.colorScheme.primary),
              borderRadius: BorderRadius.circular(16),
            ),
          )),
    );
  }

  SizedBox _buildOrDivider(Size size, BuildContext context) {
    return SizedBox(
      width: size.width * 0.9,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Divider(
              color: context.colorScheme.scrim.withOpacity(0.2),
              thickness: 1,
            ),
          ),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'veya',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.scrim,
              ),
            ),
          ),
          const Gap(10),
          Expanded(
            child: Divider(
              color: context.colorScheme.scrim.withOpacity(0.2),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButtons(Size size) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SocialLoginButton(
                elevation: const MaterialStatePropertyAll<double>(0.0),
                strokeColor: context.colorScheme.primary,
                buttonType: SocialLoginButtonType.google,
                backgroundColor: Colors.transparent,
                text: 'Google ile devam et',
                textColor: context.colorScheme.scrim,
                onPressed: () async {
                  await ref
                      .read(loginLogicProvider.notifier)
                      .signInWithGoogle()
                      .then((bool value) => value
                          ? context.go(SGRoute.home.route)
                          : context.showErrorSnackBar(
                              message:
                                  'Bir hata oluştu. Lütfen tekrar deneyiniz.'));
                },
                borderRadius: 30),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SocialLoginButton(
                elevation: const MaterialStatePropertyAll<double>(0.0),
                strokeColor: context.colorScheme.primary,
                backgroundColor: Colors.transparent,
                textColor: context.colorScheme.scrim,
                buttonType: SocialLoginButtonType.apple,
                text: 'Apple ile devam et',
                onPressed: () {
                  ref.read(loginLogicProvider.notifier).signInWithApple().then(
                      (bool value) => value
                          ? context.go(SGRoute.home.route)
                          : context.showErrorSnackBar(
                              message:
                                  'Bir hata oluştu. Lütfen tekrar deneyiniz.'));
                },
                borderRadius: 30),
          ),
        ],
      ),
    );
  }

  Padding _buildPrivacyPolicy() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
                color: context.colorScheme.primary,
              ),
            ),
          ),
          Text(
            'onaylamış olursunuz.',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: context.colorScheme.scrim,
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
                  color: context.colorScheme.primary,
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
