import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rescupaws/config/router/app_router.dart';
import 'package:rescupaws/ui/features/new_paw/logic/new_paw_logic.dart';
import 'package:rescupaws/utils/context_extensions.dart';

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
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            leading: IconButton(
              icon: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Hayvan Bilgileri',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )),
        backgroundColor: Colors.transparent,
        body: SizedBox(
          height: context.height,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Header section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.info_outline,
                          color: context.colorScheme.primary,
                          size: 24,
                        ),
                        const Gap(12),
                        Expanded(
                          child: Text(
                            'Lütfen patili dostunuzun temel bilgilerini girin',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurface.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),
                  
                  // Basic Information Section
                  Text(
                    'Temel Bilgiler',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const Gap(16),
                  
                  TextFormField(
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Lütfen geçerli bir isim giriniz.';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (String value) => ref
                        .read(newPawLogicProvider.notifier)
                        .setPawName(value.trim()),
                    decoration: InputDecoration(
                      labelText: 'İsim *',
                      hintText: 'Örn: Pamuk',
                      prefixIcon: const Icon(Icons.pets),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: context.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const Gap(16),
                  
                  TextFormField(
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Lütfen bir yaş giriniz.';
                      }
                      if (int.tryParse(value.trim()) == null ||
                          int.tryParse(value.trim())! < 0 ||
                          int.tryParse(value.trim())! > 300) {
                        return 'Lütfen geçerli bir yaş giriniz (0-300 ay).';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (String value) => ref
                        .read(newPawLogicProvider.notifier)
                        .setPawAge(value.trim()),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Yaş (Ay) *',
                      hintText: 'Ay cinsinden giriniz (Örn: 24)',
                      prefixIcon: const Icon(Icons.cake),
                      helperText: 'Yaşı ay cinsinden girin',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: context.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const Gap(16),

                  DropdownButtonFormField<String>(
                    validator: (String? value) {
                      if (value == null) {
                        return 'Lütfen cinsiyet seçiniz.';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'Cinsiyet *',
                      prefixIcon: const Icon(Icons.male),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: context.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: <String>['Erkek', 'Dişi'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              value == 'Erkek' ? Icons.male : Icons.female,
                              size: 20,
                              color: value == 'Erkek' ? Colors.blue : Colors.pink,
                            ),
                            const Gap(8),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        ref
                            .read(newPawLogicProvider.notifier)
                            .setPawGender(value == 'Erkek' ? 1 : 0);
                      }
                    },
                  ),
                  const Gap(24),
                  
                  // Additional Information Section
                  Text(
                    'Ek Bilgiler',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const Gap(16),
                  
                  DropdownButtonFormField<String>(
                    validator: (String? value) {
                      if (value == null) {
                        return 'Lütfen eğitim durumu seçiniz.';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'Tuvalet Eğitimi Durumu *',
                      prefixIcon: const Icon(Icons.school),
                      helperText: 'Tuvalet eğitimi alıp almadığını belirtin',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: context.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: <String>['Eğitimli', 'Eğitimsiz'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              value == 'Eğitimli' ? Icons.check_circle : Icons.info,
                              size: 20,
                              color: value == 'Eğitimli' ? Colors.green : Colors.orange,
                            ),
                            const Gap(8),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        ref
                            .read(newPawLogicProvider.notifier)
                            .setPawEducationLevel(value == 'Eğitimli' ? 1 : 0);
                      }
                    },
                  ),
                  const Gap(16),
                  
                  TextFormField(
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Lütfen açıklama giriniz.';
                      }
                      if (value.trim().length < 20) {
                        return 'Açıklama en az 20 karakter olmalıdır.';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (String value) => ref
                        .read(newPawLogicProvider.notifier)
                        .setPawDescription(value.trim()),
                    maxLength: 200,
                    maxLines: 4,
                    minLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Açıklama *',
                      hintText: 'Patili dostunuzun karakteri, alışkanlıkları, sağlık durumu hakkında bilgi verin...',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Icon(Icons.description),
                      ),
                      helperText: 'Detaylı bilgi, sahiplenme şansını artırır',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: context.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const Gap(24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.push(SGRoute.vaccineNewPaw.route);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Devam Et',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
