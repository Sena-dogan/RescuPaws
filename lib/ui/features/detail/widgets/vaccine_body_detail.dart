import 'package:flutter/material.dart';
import 'package:rescupaws/models/paw_entry_detail.dart';
import 'package:rescupaws/ui/features/detail/widgets/have_vaccine_detail.dart';

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
                    pawEntryDetailResponse!.data!.vaccine_info?.rabiesVaccine),
              ),
              HaveVaccineWidget(
                title: 'Distemper Aşısı',
                haveVaccine: tri(
                    pawEntryDetailResponse!.data!.vaccine_info?.distemperVaccine),
              ),
              HaveVaccineWidget(
                title: 'Hepatitis Aşısı',
                haveVaccine: tri(
                    pawEntryDetailResponse!.data!.vaccine_info?.hepatitisVaccine),
              ),
              HaveVaccineWidget(
                title: 'Parvovirus Aşısı',
                haveVaccine: tri(
                    pawEntryDetailResponse!.data!.vaccine_info?.parvovirusVaccine),
              ),
              HaveVaccineWidget(
                title: 'Bordotella Aşısı',
                haveVaccine: tri(
                    pawEntryDetailResponse!.data!.vaccine_info?.bordotellaVaccine),
              ),
              HaveVaccineWidget(
                title: 'Leptospirosis Aşısı',
                haveVaccine: tri(
                    pawEntryDetailResponse!.data!.vaccine_info?.leptospirosisVaccine),
              ),
              HaveVaccineWidget(
                title: 'Panleukopenia Aşısı',
                haveVaccine: tri(
                    pawEntryDetailResponse!.data!.vaccine_info?.panleukopeniaVaccine),
              ),
              HaveVaccineWidget(
                title: 'Herpesvirus and Calicivirus Aşısı',
                haveVaccine: tri(pawEntryDetailResponse!
                    .data!.vaccine_info?.herpesvirusAndCalicivirusVaccine),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
