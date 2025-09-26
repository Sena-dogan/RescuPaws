import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:pinput/pinput.dart';
import 'package:rescupaws/config/router/app_router.dart';
import 'package:rescupaws/ui/features/auth/presentation/login_logic.dart';
import 'package:rescupaws/ui/features/new_paw/widgets/save_button.dart';
import 'package:rescupaws/ui/widgets/app_bar_gone.dart';
import 'package:rescupaws/utils/context_extensions.dart';

class OtpScreen extends ConsumerWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
        ),
        child: Scaffold(
          appBar: const EmptyAppBar(),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(),
                Align(
                    child: Text('SMS Doğrulama',
                        style: context.textTheme.titleLarge)),
                const Gap(20),
                Align(
                  child: Text(
                    'Cep telefonuna tek seferlik bir kod gönderdik.',
                    style: context.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(20),
                Align(
                  child: Pinput(
                    length: 6,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: ref.watch(loginLogicProvider).otpController,
                    onCompleted: (String value) {
                      LoginLogic notifier = ref.read(loginLogicProvider.notifier);
                      notifier.verifySmsCode(value).then((bool value) {
                        if (value && context.mounted) {
                          context..showAwesomeMaterialBanner(
                            title: 'Başarılı',
                            message: 'Sms doğrulama başarılı',
                          )
                          ..go(SGRoute.home.route);
                        }
                      });
                    },

                    
                    defaultPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      constraints: BoxConstraints(
                        minHeight: 50,
                        maxWidth: context.width,
                      ),
                        decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.colorScheme.primary),
                    )),
                  ),
                ),
                const Gap(20),
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Kod eline ulaşmadı mı? '),
                    OtpTimerButton(
                      duration: 60,
                      backgroundColor: Colors.transparent,
                      buttonType: ButtonType.text_button,
                      text: Text(
                        'Yeniden Gönder',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                      onPressed: () {
                        ref
                            .read(loginLogicProvider.notifier)
                            .resendSmsCode()
                            .then((bool value) {
                          if (value) {
                            Logger().i('Otp Screen: Sms tekrar gönderildi');
                          }
                        });
                      },
                    ),
                  ],
                )
                    ),
                const Spacer(
                  flex: 2,
                ),
                SaveButton(onPressed: () {
                  context.go(SGRoute.home.route);
                }, title: 'Doğrula'),
                const Spacer(),
              ],
            ),
          ),
        ));
  }
}
