import 'package:flutter/material.dart';

import '../../../../models/paw_entry_detail.dart';
import 'have_vaccine_detail.dart';

class VaccineBody extends StatelessWidget {
  const VaccineBody({
    super.key,
    required this.pawEntryDetailResponse,
  });

  final GetPawEntryDetailResponse? pawEntryDetailResponse;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              HaveVaccineWidget(
                title: 'Rabies Aşısı',
                haveVaccine: pawEntryDetailResponse!.data!.rabies_vaccine ?? 2,
              ),
              HaveVaccineWidget(
                title: 'Distemper Aşısı',
                haveVaccine:
                    pawEntryDetailResponse!.data!.distemper_vaccine ?? 2,
              ),
              HaveVaccineWidget(
                title: 'Hepatitis Aşısı',
                haveVaccine:
                    pawEntryDetailResponse!.data!.hepatitis_vaccine ?? 2,
              ),
              HaveVaccineWidget(
                title: 'Parvovirus Aşısı',
                haveVaccine:
                    pawEntryDetailResponse!.data!.parvovirus_vaccine ?? 2,
              ),
              HaveVaccineWidget(
                title: 'Bordotella Aşısı',
                haveVaccine:
                    pawEntryDetailResponse!.data!.bordotella_vaccine ?? 2,
              ),
              HaveVaccineWidget(
                title: 'Leptospirosis Aşısı',
                haveVaccine:
                    pawEntryDetailResponse!.data!.leptospirosis_vaccine ?? 2,
              ),
              HaveVaccineWidget(
                title: 'Panleukopenia Aşısı',
                haveVaccine:
                    pawEntryDetailResponse!.data!.panleukopenia_vaccine ?? 2,
              ),
              HaveVaccineWidget(
                title: 'Herpesvirus and Calicivirus Aşısı',
                haveVaccine: pawEntryDetailResponse!
                        .data!.herpesvirus_and_calicivirus_vaccine ??
                    2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
