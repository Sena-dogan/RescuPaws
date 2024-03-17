import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../constants/assets.dart';
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
    final TextEditingController? numberController =
        ref.watch(loginLogicProvider).numberController;

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
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Lütfen telefon numaranızı giriniz';
                    } else {
                      FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: value,
                        autoRetrievedSmsCodeForTesting: '123456',
                        forceResendingToken: 1,
                        verificationCompleted:
                            (PhoneAuthCredential credential) {
                          debugPrint('verificationCompleted');
                        },
                        verificationFailed: (FirebaseAuthException e) {
                          debugPrint('verificationFailed');
                        },
                        codeSent: (String verificationId, int? resendToken) {
                          debugPrint('codeSent');
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {
                          debugPrint('codeAutoRetrievalTimeout');
                        },
                      );
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: context.colorScheme.background,
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
