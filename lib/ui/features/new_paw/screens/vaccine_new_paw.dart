import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_router.dart';
import '../../../../constants/assets.dart';
import '../../../../data/enums/new_paw_enums.dart';
import '../../../../utils/context_extensions.dart';
import '../logic/new_paw_logic.dart';
import '../model/new_paw_ui_model.dart';
import '../widgets/save_button.dart';

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
    final NewPawUiModel newPawUiModel = ref.watch(newPawLogicProvider);
    final NewPawLogic newPawLogic = ref.read(newPawLogicProvider.notifier);
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
                  newPawLogic.togglePawVaccine(Vaccines.RABIES);
                },
                isVaccineSelected: newPawUiModel.rabies_vaccine,
              ),
              NewPawHaveVaccineWidget(
                title: 'Distemper Aşısı',
                onTap: () {
                  newPawLogic.togglePawVaccine(Vaccines.DISTEMPER);
                },
                isVaccineSelected: newPawUiModel.distemper_vaccine,
              ),
              NewPawHaveVaccineWidget(
                title: 'Hepatitis Aşısı',
                onTap: () {
                  newPawLogic.togglePawVaccine(Vaccines.HEPATITIS);
                },
                isVaccineSelected: newPawUiModel.hepatitis_vaccine,
              ),
              NewPawHaveVaccineWidget(
                title: 'Parvovirus Aşısı',
                onTap: () {
                  newPawLogic.togglePawVaccine(Vaccines.PARVOVIRUS);
                },
                isVaccineSelected: newPawUiModel.parvovirus_vaccine,
              ),
              NewPawHaveVaccineWidget(
                title: 'Bordotella Aşısı',
                onTap: () {
                  newPawLogic.togglePawVaccine(Vaccines.BORDETELLA);
                },
                isVaccineSelected: newPawUiModel.bordotella_vaccine,
              ),
              NewPawHaveVaccineWidget(
                title: 'Leptospirosis Aşısı',
                onTap: () {
                  newPawLogic.togglePawVaccine(Vaccines.LEPTOSPIROSIS);
                },
                isVaccineSelected: newPawUiModel.leptospirosis_vaccine,
              ),
              NewPawHaveVaccineWidget(
                title: 'Panleukopenia Aşısı',
                onTap: () {
                  newPawLogic.togglePawVaccine(Vaccines.PANLEUKOPENIA);
                },
                isVaccineSelected: newPawUiModel.panleukopenia_vaccine,
              ),
              NewPawHaveVaccineWidget(
                title: 'Herpesvirus and Calicivirus Aşısı',
                isVaccineSelected:
                    newPawUiModel.herpesvirus_and_calicivirus_vaccine,
                onTap: () {
                  newPawLogic
                      .togglePawVaccine(Vaccines.HERPESVIRUSandCALICIVIRUS);
                },
              ),
              const SizedBox(height: 20),
              SaveButton(
                onPressed: () {
                  context.push(SGRoute.weight.route);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewPawHaveVaccineWidget extends StatelessWidget {
  const NewPawHaveVaccineWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.isVaccineSelected,
  });

  final String title;
  final bool isVaccineSelected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isVaccineSelected
                ? Colors.green.withOpacity(0.5)
                : Colors.red.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: ListTile(
          onTap: onTap,
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
              : const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
        ),
      ),
    );
  }
}
