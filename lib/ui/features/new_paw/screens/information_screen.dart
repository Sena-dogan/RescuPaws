import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_router.dart';
import '../../../../constants/assets.dart';
import '../../../../utils/context_extensions.dart';
import '../logic/new_paw_logic.dart';

class NewPawInformationScreen extends ConsumerStatefulWidget {
  const NewPawInformationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewPawInformationScreenState();
}

class _NewPawInformationScreenState extends ConsumerState<NewPawInformationScreen> {

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
          'Bilgi Ekle',
          style: context.textTheme.labelSmall,
        )),
        backgroundColor: Colors.transparent,
        body: SizedBox(
          child: Column(
            children: <Widget>[
              const Gap(16),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        onChanged: (String value) => ref
                            .read(newPawLogicProvider.notifier)
                            .setPawName(value.trim()),
                        decoration: const InputDecoration(
                          labelText: 'İsim',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink),
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
                          if (value.trim().isEmpty) {
                            return 'Lütfen geçerli bir yaş giriniz.';
                          }
                          return null;
                        },
                        onChanged: (String value) => ref
                            .read(newPawLogicProvider.notifier)
                            .setPawAge(value.trim()),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Yaş',
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      const Gap(16),
                      // Gender selection widget
                      DropdownButtonFormField<String>(
                        validator: (String? value) {
                          if (value == null) {
                            return 'Lütfen cinsiyet seçiniz.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                        hint: const Text('Cinsiyet'),
                        items: <String>['Erkek', 'Dişi'].map((String value) {
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
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                        hint: const Text('Eğitim Durumu'),
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
                                .setPawGender(value == 'Eğitimli' ? 1 : 0);
                        },
                      ),
                      TextFormField(
                        validator: (String? value) {
                          if (value != null && value.trim().isEmpty) {
                            return 'Lütfen açıklama giriniz.';
                          }
                          return null;
                        },
                        onChanged: (String value) => ref
                            .read(newPawLogicProvider.notifier)
                            .setPawDescription(value.trim()),
                        decoration: const InputDecoration(
                          hintText: 'Açıklama',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink),
                          ),
                          
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.push(SGRoute.home.route);
                            } else {
                              context.showErrorSnackBar(
                                title: 'Hata',
                                message:
                                    'Lütfen bilgileri eksiksiz doldurunuz.',
                              );
                            }
                          },
                          child: const Text('Kaydet'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
