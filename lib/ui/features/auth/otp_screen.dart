import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../../../config/router/app_router.dart';
import '../../../constants/assets.dart';
import '../../../utils/context_extensions.dart';
import '../../widgets/app_bar_gone.dart';
import '../new_paw/widgets/save_button.dart';
import 'login_logic.dart';

class OtpScreen extends ConsumerWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
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
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Spacer(),
                Align(
                    child: Text('SMS Doğrulama',
                        style: context.textTheme.titleLarge)),
                const Gap(20),
                Text(
                  'Cep telefonuna tek seferlik bir kod gönderdik.',
                  style: context.textTheme.bodyMedium,
                ),
                const Gap(20),
                OTPTextField(
                  length: 6,
                  width: MediaQuery.sizeOf(context).width,
                  fieldWidth: 50,
                  style: const TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onCompleted: (String pin) {
                    ref
                        .read(loginLogicProvider.notifier)
                        .verifySmsCode(pin)
                        .then((bool value) {
                      if (value) {
                        context.showAwesomeMaterialBanner(
                          title: 'Başarılı',
                          message: 'Sms doğrulama başarılı',
                        );
                        context.go(SGRoute.home.route);
                      }
                    });
                  },
                ),
                const Gap(20),
                Center(
                  child: RichText(
                      text: TextSpan(
                    text: 'Kod eline ulaşmadı mı? ',
                    style: context.textTheme.bodySmall,
                    children: <InlineSpan>[
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            ref
                                .read(loginLogicProvider.notifier)
                                .resendSmsCode()
                                .then((bool value) {
                              if (value) {
                                context.showAwesomeMaterialBanner(
                                  title: 'Başarılı',
                                  message: 'Sms tekrar gönderildi',
                                );
                              }
                            });
                          },
                        text: 'Yeniden gönder.',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ],
                  )),
                ),
                const Spacer(
                  flex: 2,
                ),
                SaveButton(
                    onPressed: () {
                      
                    },
                    title: 'Devam Et'),
                const Spacer(),
              ],
            ),
          ),
        ));
  }
}
