import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_router.dart';
import '../../../../constants/assets.dart';
import '../../../../utils/context_extensions.dart';
import '../logic/new_paw_logic.dart';
import '../widgets/save_button.dart';

class NewPawInformationScreen extends ConsumerStatefulWidget {
  const NewPawInformationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewPawInformationScreenState();
}

class _NewPawInformationScreenState
    extends ConsumerState<NewPawInformationScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              'Hayvan Bilgileri',
              style: context.textTheme.labelSmall,
            )),
        backgroundColor: Colors.transparent,
        body: SizedBox(
          height: context.height,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Gap(16),
                  SizedBox(
                    height: context.height * 0.8,
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (String? value) {
                                if (value != null && value.trim().isEmpty) {
                                  return 'Lütfen geçerli bir isim giriniz.';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onChanged: (String value) => ref
                                  .read(newPawLogicProvider.notifier)
                                  .setPawName(value.trim()),
                              decoration: const InputDecoration(
                                labelText: 'İsim',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                            const Gap(16),
                            TextFormField(
                              validator: (String? value) {
                                if (value != null &&
                                        int.tryParse(value.trim()) == null ||
                                    int.tryParse(value!.trim())! < 0 ||
                                    int.tryParse(value.trim())! > 50) {
                                  return 'Lütfen geçerli bir yaş giriniz.';
                                }
                                if (value == null && value.trim().isEmpty) {
                                  return 'Lütfen bir yaş giriniz.';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onChanged: (String value) => ref
                                  .read(newPawLogicProvider.notifier)
                                  .setPawAge(value.trim()),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Yaş',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  hintText: 'Ay cinsinden giriniz.'),
                            ),

                            const Gap(16),

                            DropdownButtonFormField<String>(
                              validator: (String? value) {
                                if (value == null) {
                                  return 'Lütfen cinsiyet seçiniz.';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                labelText: 'Cinsiyet',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              items:
                                  <String>['Erkek', 'Dişi'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value != null)
                                  ref
                                      .read(newPawLogicProvider.notifier)
                                      .setPawGender(value == 'Erkek' ? 1 : 0);
                              },
                            ),
                            const Gap(16),
                            // Pet Education level selection widget
                            DropdownButtonFormField<String>(
                              validator: (String? value) {
                                if (value == null) {
                                  return 'Lütfen eğitim durumu seçiniz.';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                labelText: 'Tuvalet Eğitimi Durumu',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              items: <String>['Eğitimli', 'Eğitimsiz']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value != null)
                                  ref
                                      .read(newPawLogicProvider.notifier)
                                      .setPawEducationLevel(
                                          value == 'Eğitimli' ? 1 : 0);
                              },
                            ),
                            const Gap(16),
                            TextFormField(
                              validator: (String? value) {
                                if (value != null && value.trim().isEmpty) {
                                  return 'Lütfen "açıklama" giriniz.';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onChanged: (String value) => ref
                                  .read(newPawLogicProvider.notifier)
                                  .setPawDescription(value.trim()),
                              maxLength: 200,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: 'Açıklama',
                                hintText:
                                    "Pati'li dostunuz hakkında bilgi verin.",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                            const Spacer(),
                            //TODO: Make save button widget
                            SaveButton(
                              onPressed: () {
                                context.push(SGRoute.vaccineNewPaw.route);
                              },
                            ),
                          ].seperate(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
