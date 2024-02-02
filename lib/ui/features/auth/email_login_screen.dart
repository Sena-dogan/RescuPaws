import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/router/app_router.dart';
import '../../../constants/assets.dart';
import '../../../utils/context_extensions.dart';
import '../../widgets/app_bar_gone.dart';
import 'login_logic.dart';
import 'login_ui_model.dart';

class EmailLoginScreen extends ConsumerStatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailLoginScreenState();
}

class _EmailLoginScreenState extends ConsumerState<EmailLoginScreen> {
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
        appBar: const EmptyAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(),
              Text(
                'Giriş Yap',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.scrim,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: size.width * 0.8,
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
                        borderSide:
                            BorderSide(color: context.colorScheme.primary),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: context.colorScheme.primary),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: context.colorScheme.primary),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    )),
              ),
              const Gap(10),
              SizedBox(
                width: size.width * 0.8,
                height: 50,
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: loginModel.isObscure,
                  onChanged: (String value) {
                    ref
                        .read(loginLogicProvider.notifier)
                        .passwordChanged(value);
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
                      borderSide:
                          BorderSide(color: context.colorScheme.primary),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: context.colorScheme.primary),
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
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: context.colorScheme.scrim,
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(10),
              SizedBox(
                width: size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(loginLogicProvider.notifier)
                        .signInWithEmailAndPassword()
                        .catchError((Object? err) {
                      if (err is SocketException) {
                        context.showErrorSnackBar(
                            message: 'İnternet bağlantınızı kontrol edin.');
                      } else if (err is FormatException) {
                        context.showErrorSnackBar(
                            message: 'E-posta adresi geçersiz.');
                      } else {
                        context.showErrorSnackBar(
                            message:
                                'Bir hata oluştu. Daha sonra tekrar deneyin.');
                      }
                    }).then(
                      (_) => context.go(SGRoute.login.route),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colorScheme.primary,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                  ),
                  child: const Text('Giriş Yap'),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ref
                        .read(loginLogicProvider.notifier)
                        .forgotPassword()
                        .catchError((Object? err) {
                      if (err is SocketException) {
                        context.showErrorSnackBar(
                            message: 'İnternet bağlantınızı kontrol edin.');
                      } else if (err is FormatException) {
                        context.showErrorSnackBar(
                            message: 'E-posta adresi geçersiz.');
                      } else {
                        context.showErrorSnackBar(
                            message:
                                'Bir hata oluştu. Daha sonra tekrar deneyin.');
                      }
                    }).then(
                      (_) => context.showAwesomeMaterialBanner(
                          message:
                              'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.',
                          title: 'Başarılı'),
                    );
                  },
                  child: Text(
                    'Şifremi Unuttum',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colorScheme.scrim,
                    ),
                  ),
                ),
              ),
              const Gap(20),
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
          Text('ve ',
              style: GoogleFonts.outfit(
                  fontSize: 14, fontWeight: FontWeight.w400)),
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
                  decoration: TextDecoration.underline,
                  color: context.colorScheme.scrim,
                ),
              ),
            ),
            Text('kabul etmiş',
                style: GoogleFonts.outfit(
                    fontSize: 14, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
