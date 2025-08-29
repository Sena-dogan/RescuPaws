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
import '../../home/widgets/loading_paw_widget.dart';
import 'login_logic.dart';
import 'login_ui_model.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final LoginUiModel loginModel = ref.watch(loginLogicProvider);
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
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
              child: TextButton(
                onPressed: () {
                  context.go(SGRoute.login.route);
                },
                child: Text('Giriş Yap',
                    style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.primary, fontSize: 16)),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: size.width,
            height: size.height * 0.9,
            child: loginModel.isLoading
                ? const Center(child: LoadingPawWidget())
                : Column(
                    children: <Widget>[
                      Gap(size.height * 0.05),
                      _loginText(context),
                      const Gap(25),
                      _buildEmail(size, context),
                      const Gap(16),
                      _buildPass(size, loginModel, context),
                      const Gap(16),
                      _buildPassConfirm(size, loginModel, context),
                      const Gap(16),
                      _buildTermsOfService(),
                      _buildPrivacyPolicy(),
                      const Spacer(),
                      _buildSignInButton(context),
                      _alreadyHaveAccount(context),
                      const Spacer(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Text _loginText(BuildContext context) {
    return Text(
      'Kayıt Ol',
      style: context.textTheme.labelSmall
          ?.copyWith(color: context.colorScheme.scrim),
    );
  }

  Widget _alreadyHaveAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Zaten bir Hesabın var mı?',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.scrim,
          ),
        ),
        TextButton(
          onPressed: () {
            context.go(SGRoute.login.route);
          },
          child: Text(
            'Giriş Yap',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  SizedBox _buildSignInButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.9,
      child: ElevatedButton(
        onPressed: () async {
          await ref
              .read(loginLogicProvider.notifier)
              .signUpWithEmailAndPassword()
              .catchError((Object? err) {
            debugPrint(err.toString());
            context.showErrorSnackBar(
                message: 'Bir hata oluştu. Lütfen tekrar deneyiniz.');
            return false;
          }).then((bool value) {
            if (value) {
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
          'Kayıt Ol',
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.colorScheme.surface,
          ),
        ),
      ),
    );
  }

  SizedBox _buildPass(
      Size size, LoginUiModel loginModel, BuildContext context) {
    return SizedBox(
      width: size.width * 0.9,
      child: TextFormField(
        controller: _passwordController,
        obscureText: loginModel.isObscure,
        onChanged: (String value) {
          ref.read(loginLogicProvider.notifier).passwordChanged(value);
        },
        keyboardType: loginModel.isObscure
            ? TextInputType.visiblePassword
            : TextInputType.text,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? value) {
          // Min 8 characters, at least one uppercase and lowercase and special character
          if (value == null || value.isEmpty) {
            return 'Lütfen şifrenizi giriniz';
          } else if (value.length < 8) {
            return 'Şifreniz en az 8 karakter olmalıdır';
          } else if (!value.contains(RegExp(r'[A-Z]'))) {
            return 'Şifreniz en az bir büyük harf içermelidir';
          } else if (!value.contains(RegExp(r'[a-z]'))) {
            return 'Şifreniz en az bir küçük harf içermelidir';
          } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
            return 'Şifreniz en az bir özel karakter içermelidir';
          }
          return null;
        },
        autofillHints: const <String>[AutofillHints.password],
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        decoration: _passDecoration(context, loginModel),
      ),
    );
  }

  SizedBox _buildEmail(Size size, BuildContext context) {
    return SizedBox(
      width: size.width * 0.9,
      child: TextFormField(
          controller: _emailController,
          onChanged: (String value) {
            ref.read(loginLogicProvider.notifier).emailChanged(value);
          },
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Lütfen e-posta adresinizi giriniz';
            } else if (!value.contains('@')) {
              return 'Lütfen geçerli bir e-posta adresi giriniz';
            }
            return null;
          },
          autofillHints: const <String>[AutofillHints.email],
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          decoration: _emailDecoration(context)),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: context.colorScheme.scrim)),
          ],
        ),
      ),
    );
  }

  Widget _buildPassConfirm(
      Size size, LoginUiModel loginModel, BuildContext context) {
    return SizedBox(
      width: size.width * 0.9,
      child: TextFormField(
        controller: _passwordConfirmController,
        obscureText: loginModel.isObscure,
        onChanged: (String value) {
          ref.read(loginLogicProvider.notifier).passwordConfirmChanged(value);
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.done,
        onEditingComplete: () {
          if (_passwordController.text == _passwordConfirmController.text) {
            ref
                .read(loginLogicProvider.notifier)
                .signUpWithEmailAndPassword()
                .then((bool value) {
              if (value) {
                context.go(SGRoute.home.route);
              }
            });
          }
        },
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Lütfen şifrenizi tekrar giriniz';
          } else if (value != _passwordController.text) {
            return 'Şifreler eşleşmiyor';
          }
          return null;
        },
        autofillHints: const <String>[AutofillHints.password],
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        decoration: _passDecoration(context, loginModel),
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
          color: context.colorScheme.scrim.withOpacity(0.5),
        ),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }
}
