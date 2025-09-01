import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/router/app_router.dart';
import '../../../utils/context_extensions.dart';
import '../../home/widgets/loading_paw_widget.dart';
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
        color: context.colorScheme.surface,
        // image: const DecorationImage(
        //   image: AssetImage(Assets.LoginBg),
        //   fit: BoxFit.cover,
        // ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            context.colorScheme.surface,
            context.colorScheme.primaryContainer,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: context.colorScheme.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            _buildRegisterButton(context),
          ],
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: size.width,
            height: size.height * 0.9,
            child: loginModel.isLoading
                ? const Center(
                    child: LoadingPawWidget(),
                  )
                : Column(
                    children: <Widget>[
                      Gap(size.height * 0.05),
                      LoginText(context: context),
                      const Gap(25),
                      LoginButtons(
                          context: context,
                          ref: ref,
                          size: Size(size.width, size.height * 0.12)),
                      const Gap(25),
                      OrDivider(size: size, context: context),
                      const Gap(25),
                      EmailText(context: context),
                      const Gap(25),
                      _buildEmail(size, context),
                      const Gap(16),
                      _buildPass(size, loginModel, context),
                      const Gap(16),
                      _buildTermsOfService(),
                      _buildPrivacyPolicy(),
                      const Gap(16),
                      SignInButton(ref: ref, context: context),
                      _forgotPasswordButton(context),
                      const Spacer(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Padding _buildRegisterButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: () {
          context.go(SGRoute.register.route);
        },
        child: Text(
          'Kayıt Ol',
          style: context.textTheme.labelSmall
              ?.copyWith(color: context.colorScheme.primary, fontSize: 16),
        ),
      ),
    );
  }

  TextButton _forgotPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await ref
            .read(loginLogicProvider.notifier)
            .forgotPassword()
            .catchError((Object? err) {
          debugPrint('Error caught: $err');
          if (!context.mounted) return false;
          context.showErrorSnackBar(message: err.toString());
          return false;
        }).then((bool value) {
          if (value && context.mounted) {
            context.showAwesomeMaterialBanner(
                title: 'Başarılı',
                message:
                    'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi');
          }
        });
      },
      child: Text(
        'Şifremi unuttum',
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.primary,
        ),
      ),
    );
  }

  SizedBox _buildPass(
      Size size, LoginUiModel loginModel, BuildContext context) {
    return SizedBox(
      width: size.width * 0.9,
      child: AutofillGroup(
        child: TextFormField(
          controller: _passwordController,
          obscureText: loginModel.isObscure,
          onChanged: (String value) {
            ref.read(loginLogicProvider.notifier).passwordChanged(value);
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Lütfen şifrenizi giriniz';
            } else if (value.length < 6) {
              return 'Şifreniz en az 6 karakter olmalıdır';
            }
            return null;
          },
          keyboardType: loginModel.isObscure
              ? TextInputType.text
              : TextInputType.visiblePassword,
          autofillHints: const <String>[AutofillHints.password],
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          onEditingComplete: () => ref
              .read(loginLogicProvider.notifier)
              .signInWithEmailAndPassword()
              .then((bool value) {
            if (!context.mounted) return;
            value
                ? context.go(SGRoute.home.route)
                : context.showErrorSnackBar(
                    message: 'Bir hata oluştu. Lütfen tekrar deneyiniz.');
          }),
          decoration: _passDecoration(context, loginModel),
        ),
      ),
    );
  }

  InputDecoration _passDecoration(
      BuildContext context, LoginUiModel loginModel) {
    return InputDecoration(
      hintText: 'Şifre',
      hintStyle: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.scrim,
      ),
      errorStyle: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.error,
      ),
      fillColor: context.colorScheme.surface,
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
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: context.colorScheme.error),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: context.colorScheme.error),
        borderRadius: BorderRadius.circular(16),
      ),
      suffixIcon: IconButton(
        onPressed: () {
          ref.read(loginLogicProvider.notifier).toggleObscure();
        },
        icon: Icon(
          loginModel.isObscure
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: context.colorScheme.scrim.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildEmail(Size size, BuildContext context) {
    return SizedBox(
      width: size.width * 0.9,
      child: AutofillGroup(
        child: TextFormField(
            controller: _emailController,
            onChanged: (String value) {
              ref.read(loginLogicProvider.notifier).emailChanged(value);
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen e-posta adresinizi giriniz';
              } else if (!value.contains('@')) {
                return 'Lütfen geçerli bir e-posta adresi giriniz';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const <String>[AutofillHints.email],
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
            ],
            decoration: _emailDecoration(context)),
      ),
    );
  }

  InputDecoration _emailDecoration(BuildContext context) {
    return InputDecoration(
      hintText: 'E-posta',
      hintStyle: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.scrim,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: context.colorScheme.error),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: context.colorScheme.error),
        borderRadius: BorderRadius.circular(16),
      ),
      errorStyle: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.error,
      ),
      fillColor: context.colorScheme.surface,
      filled: true,
      contentPadding: const EdgeInsets.all(15),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: context.colorScheme.primary),
        borderRadius: BorderRadius.circular(16),
      ),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class LoginButtons extends StatelessWidget {
  const LoginButtons({
    super.key,
    required this.context,
    required this.ref,
    required this.size,
  });

  final BuildContext context;
  final WidgetRef ref;
  final Size size;

  @override
  Widget build(BuildContext context) {
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
                elevation: const WidgetStatePropertyAll<double>(0.0),
                strokeColor: context.colorScheme.primary,
                buttonType: SocialLoginButtonType.google,
                backgroundColor: Colors.transparent,
                text: 'Google ile devam et',
                textColor: context.colorScheme.scrim,
                onPressed: () async {
                  await ref
                      .watch(loginLogicProvider.notifier)
                      .signInWithGoogle()
                      .then((bool value) {
                    if (!context.mounted) return false;

                    value
                        ? context.go(SGRoute.home.route)
                        : context.showErrorSnackBar(
                            message:
                                'Bir hata oluştu. Lütfen tekrar deneyiniz.');
                  });
                },
                borderRadius: 30),
          ),
          Visibility(
            visible: context.isIOS,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SocialLoginButton(
                  elevation: const WidgetStatePropertyAll<double>(0.0),
                  strokeColor: context.colorScheme.primary,
                  backgroundColor: Colors.transparent,
                  textColor: context.colorScheme.scrim,
                  buttonType: SocialLoginButtonType.apple,
                  text: 'Apple ile devam et',
                  onPressed: () {
                    ref
                        .watch(loginLogicProvider.notifier)
                        .signInWithApple()
                        .then((bool value) {
                      if (!context.mounted) return;
                      value
                          ? context.go(SGRoute.home.route)
                          : context.showErrorSnackBar(
                              message:
                                  'Bir hata oluştu. Lütfen tekrar deneyiniz.');
                    });
                  },
                  borderRadius: 30),
            ),
          ),
        ],
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({
    super.key,
    required this.size,
    required this.context,
  });

  final Size size;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.9,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Divider(
              color: context.colorScheme.scrim.withValues(alpha: 0.2),
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
              color: context.colorScheme.scrim.withValues(alpha: 0.2),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
    required this.ref,
    required this.context,
  });

  final WidgetRef ref;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.9,
      height: 48,
      child: ElevatedButton(
        onPressed: () async {
          await ref
              .read(loginLogicProvider.notifier)
              .signInWithEmailAndPassword()
              .catchError((Object? err) {
            if (!context.mounted) return false;

            if (err is FirebaseAuthException) {
              switch (err.code) {
                case 'invalid-email':
                  context.showErrorSnackBar(
                      message: 'Lütfen geçerli bir e-posta adresi giriniz.');
                  break;
                case 'user-not-found':
                  context.showErrorSnackBar(
                      message: 'Bu e-posta adresi ile bir hesap bulunamadı.');
                  break;
                case 'wrong-password':
                  context.showErrorSnackBar(
                      message: 'Şifreniz yanlış. Lütfen tekrar deneyiniz.');
                  break;
                default:
                  context.showErrorSnackBar(
                      message: 'Bir hata oluştu. Lütfen tekrar deneyiniz.');
              }
            } else if (err is FormatException) {
              context.showErrorSnackBar(
                  message: 'Lütfen e-posta adresi ve şifrenizi giriniz.');
            } else {
              Logger().e(err);
              context.showErrorSnackBar(
                  message: 'Bir hata oluştu. Lütfen tekrar deneyiniz.');
            }
            return false;
          }).then((bool value) {
            if (value && context.mounted) {
              context.go(SGRoute.home.route);
            }
          });
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
            color: context.colorScheme.surface,
          ),
        ),
      ),
    );
  }
}

class EmailText extends StatelessWidget {
  const EmailText({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Text('E-posta ile devam edin', style: context.textTheme.labelSmall);
  }
}

class LoginText extends StatelessWidget {
  const LoginText({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Giriş Yap',
      style: context.textTheme.labelSmall
          ?.copyWith(color: context.colorScheme.scrim),
    );
  }
}
