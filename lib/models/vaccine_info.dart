import 'package:freezed_annotation/freezed_annotation.dart';

part 'vaccine_info.freezed.dart';
part 'vaccine_info.g.dart';

/// Grouped vaccination details for a paw entry.
@freezed
abstract class VaccineInfo with _$VaccineInfo {
  const factory VaccineInfo({
    bool? rabies_vaccine,
    bool? distemper_vaccine,
    bool? hepatitis_vaccine,
    bool? parvovirus_vaccine,
    bool? bordotella_vaccine,
    bool? leptospirosis_vaccine,
    bool? panleukopenia_vaccine,
    bool? herpesvirus_and_calicivirus_vaccine,
  }) = _VaccineInfo;

  factory VaccineInfo.fromJson(Map<String, dynamic> json) =>
      _$VaccineInfoFromJson(json);
}

extension VaccineInfoX on VaccineInfo {
  /// Returns true if the pet has received any vaccine.
  bool get hasAnyVaccine {
    return (rabies_vaccine ?? false) ||
        (distemper_vaccine ?? false) ||
        (hepatitis_vaccine ?? false) ||
        (parvovirus_vaccine ?? false) ||
        (bordotella_vaccine ?? false) ||
        (leptospirosis_vaccine ?? false) ||
        (panleukopenia_vaccine ?? false) ||
        (herpesvirus_and_calicivirus_vaccine ?? false);
  }
}
