import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../../../config/router/app_router.dart';
import '../../../constants/assets.dart';
import '../../../utils/context_extensions.dart';
import '../../widgets/app_bar_gone.dart';

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
                'Sign in',
                style: context.textTheme.labelLarge,
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
                  buttonType: SocialLoginButtonType.appleBlack,
                  onPressed: () {
                    context.go(SGRoute.intro.route);
                  },
                  borderRadius: 30),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SocialLoginButton(
                  buttonType: SocialLoginButtonType.google,
                  onPressed: () {},
                  borderRadius: 30),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SocialLoginButton(
                  buttonType: SocialLoginButtonType.facebook,
                  onPressed: () {},
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
          Text('acknowledge receipt of our ',
              style: GoogleFonts.outfit(
                  fontSize: 14, fontWeight: FontWeight.w400)),
          GestureDetector(
            onTap: () {},
            child: Text('Privacy Policy',
                style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline)),
          ),
        ],
      ),
    );
  }

  Padding _buildTermsOfService() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'By sign in, you accept our ',
            style:
                GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Terms of Service',
              style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline),
            ),
          ),
          Text(' and ',
              style: GoogleFonts.outfit(
                  fontSize: 14, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
