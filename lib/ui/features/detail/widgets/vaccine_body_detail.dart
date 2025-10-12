import 'package:flutter/material.dart';
import 'package:rescupaws/models/paw_entry_detail.dart';
import 'package:rescupaws/models/vaccine_info.dart';
import 'package:rescupaws/ui/features/detail/widgets/have_vaccine_detail.dart';

class VaccineBody extends StatelessWidget {
  const VaccineBody({
    super.key,
    required this.pawEntryDetailResponse,
  });

  final GetPawEntryDetailResponse? pawEntryDetailResponse;

  @override
  Widget build(BuildContext context) {
    // Helper to check if vaccine exists in array: 1 = has vaccine, 0 = doesn't have, 2 = unknown
    int hasVaccine(String vaccineName) {
      if (pawEntryDetailResponse?.data?.vaccines == null) return 2;
      return pawEntryDetailResponse!.data!.vaccines.contains(vaccineName) ? 1 : 0;
    }
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              HaveVaccineWidget(
                title: 'Rabies Aşısı',
                haveVaccine: hasVaccine(VaccineNames.rabies),
              ),
              HaveVaccineWidget(
                title: 'Distemper Aşısı',
                haveVaccine: hasVaccine(VaccineNames.distemper),
              ),
              HaveVaccineWidget(
                title: 'Hepatitis Aşısı',
                haveVaccine: hasVaccine(VaccineNames.hepatitis),
              ),
              HaveVaccineWidget(
                title: 'Parvovirus Aşısı',
                haveVaccine: hasVaccine(VaccineNames.parvovirus),
              ),
              HaveVaccineWidget(
                title: 'Bordotella Aşısı',
                haveVaccine: hasVaccine(VaccineNames.bordetella),
              ),
              HaveVaccineWidget(
                title: 'Leptospirosis Aşısı',
                haveVaccine: hasVaccine(VaccineNames.leptospirosis),
              ),
              HaveVaccineWidget(
                title: 'Panleukopenia Aşısı',
                haveVaccine: hasVaccine(VaccineNames.panleukopenia),
              ),
              HaveVaccineWidget(
                title: 'Herpesvirus and Calicivirus Aşısı',
                haveVaccine: hasVaccine(VaccineNames.herpesvirusCalicivirus),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
