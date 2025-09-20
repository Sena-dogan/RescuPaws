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
  int tri(bool? v) => v == null ? 2 : (v ? 1 : 0);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              HaveVaccineWidget(
                title: 'Rabies Aşısı',
                haveVaccine: tri(
                    pawEntryDetailResponse!.data!.vaccine_info?.rabies_vaccine),
              ),
              HaveVaccineWidget(
                title: 'Distemper Aşısı',
                haveVaccine: tri(
                    pawEntryDetailResponse!.data!.vaccine_info?.distemper_vaccine),
              ),
              HaveVaccineWidget(
                title: 'Hepatitis Aşısı',
                haveVaccine: tri(
                    pawEntryDetailResponse!.data!.vaccine_info?.hepatitis_vaccine),
              ),
              HaveVaccineWidget(
                title: 'Parvovirus Aşısı',
                haveVaccine: tri(
                    pawEntryDetailResponse!.data!.vaccine_info?.parvovirus_vaccine),
              ),
              HaveVaccineWidget(
                title: 'Bordotella Aşısı',
                haveVaccine: tri(
                    pawEntryDetailResponse!.data!.vaccine_info?.bordotella_vaccine),
              ),
              HaveVaccineWidget(
                title: 'Leptospirosis Aşısı',
                haveVaccine: tri(
                    pawEntryDetailResponse!.data!.vaccine_info?.leptospirosis_vaccine),
              ),
              HaveVaccineWidget(
                title: 'Panleukopenia Aşısı',
                haveVaccine: tri(
                    pawEntryDetailResponse!.data!.vaccine_info?.panleukopenia_vaccine),
              ),
              HaveVaccineWidget(
                title: 'Herpesvirus and Calicivirus Aşısı',
                haveVaccine: tri(pawEntryDetailResponse!
                    .data!.vaccine_info?.herpesvirus_and_calicivirus_vaccine),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
