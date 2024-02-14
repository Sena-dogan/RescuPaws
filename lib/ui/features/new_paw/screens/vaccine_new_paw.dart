import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_router.dart';
import '../../../../constants/assets.dart';
import '../../../../data/enums/new_paw_enums.dart';
import '../../../../utils/context_extensions.dart';
import '../logic/new_paw_logic.dart';

class VaccinesNewPaw extends ConsumerWidget {
  const VaccinesNewPaw({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          appBar: AppBar(
            leading: IconButton(
              icon: Container(
                height: 50,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                context.pop();
              },
            ),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              'Aşılar',
              style: context.textTheme.labelSmall,
            ),
          ),
          body: const VaccineCreateBody(),
        ));
  }
}

class VaccineCreateBody extends ConsumerStatefulWidget {
  const VaccineCreateBody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VaccineCreateBodyState();
}

class _VaccineCreateBodyState extends ConsumerState<VaccineCreateBody> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NewPawHaveVaccineWidget(
                title: 'Rabies Aşısı',
                onTap: () {
                  ref
                      .read(newPawLogicProvider.notifier)
                      .setVaccineSelected(true);
                  ref
                      .read(newPawLogicProvider.notifier)
                      .setPawVaccine(Vaccines.RABIES, 1);
                },
              ),
              NewPawHaveVaccineWidget(
                title: 'Distemper Aşısı',
                onTap: () {
                  ref
                      .read(newPawLogicProvider.notifier)
                      .setVaccineSelected(true);
                  ref
                      .read(newPawLogicProvider.notifier)
                      .setPawVaccine(Vaccines.DISTEMPER, 1);
                },
              ),
              NewPawHaveVaccineWidget(
                title: 'Hepatitis Aşısı',
                onTap: () {
                  ref
                      .read(newPawLogicProvider.notifier)
                      .setVaccineSelected(true);
                  ref
                      .read(newPawLogicProvider.notifier)
                      .setPawVaccine(Vaccines.HEPATITIS, 1);
                },
              ),
              NewPawHaveVaccineWidget(
                title: 'Parvovirus Aşısı',
                onTap: () {
                  ref
                      .read(newPawLogicProvider.notifier)
                      .setVaccineSelected(true);
                  ref
                      .read(newPawLogicProvider.notifier)
                      .setPawVaccine(Vaccines.PARVOVIRUS, 1);
                },
              ),
              NewPawHaveVaccineWidget(
                title: 'Bordotella Aşısı',
                onTap: () {
                  ref
                      .read(newPawLogicProvider.notifier)
                      .setVaccineSelected(true);
                  ref
                      .read(newPawLogicProvider.notifier)
                      .setPawVaccine(Vaccines.BORDETELLA, 1);
                },
              ),
              NewPawHaveVaccineWidget(
                title: 'Leptospirosis Aşısı',
                onTap: () {
                  ref
                      .read(newPawLogicProvider.notifier)
                      .setVaccineSelected(true);
                  ref
                      .read(newPawLogicProvider.notifier)
                      .setPawVaccine(Vaccines.LEPTOSPIROSIS, 1);
                },
              ),
              NewPawHaveVaccineWidget(
                title: 'Panleukopenia Aşısı',
                onTap: () {
                  ref
                      .read(newPawLogicProvider.notifier)
                      .setVaccineSelected(true);
                  ref
                      .read(newPawLogicProvider.notifier)
                      .setPawVaccine(Vaccines.PANLEUKOPENIA, 1);
                },
              ),
              NewPawHaveVaccineWidget(
                title: 'Herpesvirus and Calicivirus Aşısı',
                onTap: () {
                  ref
                      .read(newPawLogicProvider.notifier)
                      .setVaccineSelected(true);
                  ref
                      .read(newPawLogicProvider.notifier)
                      .setPawVaccine(Vaccines.HERPESVIRUSandCALICIVIRUS, 1);
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      Size(
                        context.width * 0.8,
                        context.height * 0.06,
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.push(SGRoute.weight.route);
                    }
                  },
                  child: Text(
                    'Kaydet',
                    style: context.textTheme.labelMedium,
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

class NewPawHaveVaccineWidget extends ConsumerWidget {
  const NewPawHaveVaccineWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isVaccineSelected =
        ref.read(newPawLogicProvider).isVaccineSelected;
    final Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isVaccineSelected
                  ? Colors.green.withOpacity(0.4)
                  : !isVaccineSelected
                      ? Colors.red.withOpacity(0.4)
                      : Colors.grey.withOpacity(0.4),
              width: 2,
            ),
          ),
          child: ListTile(
            title: Text(
              title,
              style: context.textTheme.bodyLarge,
              selectionColor: context.colorScheme.scrim,
            ),
            trailing: isVaccineSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : !isVaccineSelected
                    ? const Icon(
                        Icons.close,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.help,
                        color: Colors.grey,
                      ),
          ),
        ),
      ),
    );
  }
}
