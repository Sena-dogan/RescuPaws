import 'package:freezed_annotation/freezed_annotation.dart';

part 'vaccine_info.freezed.dart';
part 'vaccine_info.g.dart';

/// Grouped vaccination details for a paw entry.
@freezed
abstract class VaccineInfo with _$VaccineInfo {
  const factory VaccineInfo({
    @JsonKey(name: 'rabies_vaccine') bool? rabiesVaccine,
    @JsonKey(name: 'distemper_vaccine') bool? distemperVaccine,
    @JsonKey(name: 'hepatitis_vaccine') bool? hepatitisVaccine,
    @JsonKey(name: 'parvovirus_vaccine') bool? parvovirusVaccine,
    @JsonKey(name: 'bordotella_vaccine') bool? bordotellaVaccine,
    @JsonKey(name: 'leptospirosis_vaccine') bool? leptospirosisVaccine,
    @JsonKey(name: 'panleukopenia_vaccine') bool? panleukopeniaVaccine,
    @JsonKey(name: 'herpesvirus_and_calicivirus_vaccine') bool? herpesvirusAndCalicivirusVaccine,
  }) = _VaccineInfo;

  factory VaccineInfo.fromJson(Map<String, dynamic> json) =>
      _$VaccineInfoFromJson(json);
}

extension VaccineInfoX on VaccineInfo {
  /// Returns true if the pet has received any vaccine.
  bool get hasAnyVaccine {
    return (rabiesVaccine ?? false) ||
        (distemperVaccine ?? false) ||
        (hepatitisVaccine ?? false) ||
        (parvovirusVaccine ?? false) ||
        (bordotellaVaccine ?? false) ||
        (leptospirosisVaccine ?? false) ||
        (panleukopeniaVaccine ?? false) ||
        (herpesvirusAndCalicivirusVaccine ?? false);
  }
}
