import 'package:freezed_annotation/freezed_annotation.dart';

part 'vaccine_info.freezed.dart';
part 'vaccine_info.g.dart';

/// Vaccination details for a paw entry stored as an array of vaccine names.
/// This is much more Firestore-friendly than nested boolean maps.
@freezed
abstract class VaccineInfo with _$VaccineInfo {
  const factory VaccineInfo({
    @Default(<String>[]) List<String> vaccines,
  }) = _VaccineInfo;

  factory VaccineInfo.fromJson(Map<String, dynamic> json) =>
      _$VaccineInfoFromJson(json);
}

/// Vaccine name constants for consistency
class VaccineNames {
  static const String rabies = 'rabies';
  static const String distemper = 'distemper';
  static const String hepatitis = 'hepatitis';
  static const String parvovirus = 'parvovirus';
  static const String bordetella = 'bordetella';
  static const String leptospirosis = 'leptospirosis';
  static const String panleukopenia = 'panleukopenia';
  static const String herpesvirusCalicivirus = 'herpesvirus_calicivirus';
  
  /// Get all available vaccine names
  static const List<String> all = <String>[
    rabies,
    distemper,
    hepatitis,
    parvovirus,
    bordetella,
    leptospirosis,
    panleukopenia,
    herpesvirusCalicivirus,
  ];
}

extension VaccineInfoX on VaccineInfo {
  /// Returns true if the pet has received any vaccine.
  bool get hasAnyVaccine => vaccines.isNotEmpty;
  
  /// Check if a specific vaccine is included
  bool hasVaccine(String vaccineName) => vaccines.contains(vaccineName);
}
