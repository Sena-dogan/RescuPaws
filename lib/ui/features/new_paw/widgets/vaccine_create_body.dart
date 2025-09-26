import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rescupaws/config/router/app_router.dart';
import 'package:rescupaws/data/enums/new_paw_enums.dart';
import 'package:rescupaws/ui/features/new_paw/logic/new_paw_logic.dart';
import 'package:rescupaws/ui/features/new_paw/model/new_paw_ui_model.dart';
import 'package:rescupaws/ui/features/new_paw/widgets/have_vaccine_new_paw.dart';
import 'package:rescupaws/ui/features/new_paw/widgets/save_button.dart';

class VaccineCreateBody extends ConsumerStatefulWidget {
  const VaccineCreateBody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VaccineCreateBodyState();
}

class _VaccineCreateBodyState extends ConsumerState<VaccineCreateBody> {
  @override
  Widget build(BuildContext context) {
    NewPawUiModel newPawUiModel = ref.watch(newPawLogicProvider);
    NewPawLogic newPawLogic = ref.read(newPawLogicProvider.notifier);
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
                title: 'Kaydet',
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
