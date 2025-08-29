import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../config/router/app_router.dart';
import '../../../utils/context_extensions.dart';
import '../../widgets/app_bar_gone.dart';
import '../new_paw/widgets/save_button.dart';
import 'login_logic.dart';

class NumberInputScreen extends ConsumerStatefulWidget {
  const NumberInputScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NumberInputScreenState();
}

class _NumberInputScreenState extends ConsumerState<NumberInputScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //TODO: Initialize the controller in better way. Maybe in initState
    final TextEditingController? numberController =
        ref.watch(loginLogicProvider).numberController;

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
                'Sevimli dostlarımızla tanışmak için telefonuna bir doğrulama kodu göndereceğiz.',
                style: context.textTheme.bodyMedium,
              ),
              const Gap(20),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: numberController,
                  inputFormatters: <TextInputFormatter>[
                    MaskTextInputFormatter(
                      initialText: '+90',
                      mask: '+__ ___ ___ ____',
                      filter: <String, RegExp>{'_': RegExp(r'[0-9]')},
                    ),
                  ],
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Lütfen telefon numaranızı giriniz';
                    } else {
                      ///TODO: Implement error handling
                      ref
                          .read(loginLogicProvider.notifier)
                          .verifyPhoneNumber(value)
                          .catchError((Object e) {
                        debugPrint(e.toString());
                        return false;
                      }).then((bool result) {
                        if (result) {
                          context.push(SGRoute.otp.route);
                        }
                      });
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: context.colorScheme.surface,
                    hintText: '+90__   __.  __.  ___',
                    hintStyle: context.textTheme.bodyMedium,
                    labelStyle: context.textTheme.bodyMedium,
                    border: _mainBorder(),
                    focusedBorder: _mainBorder(),
                    enabledBorder: _mainBorder(),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: context.colorScheme.error,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              const Spacer(
                flex: 2,
              ),
              SaveButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      debugPrint('Devam Et');
                    }
                  },
                  title: 'Devam Et'),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _mainBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
    );
  }
}
