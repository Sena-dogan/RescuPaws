# Vaccine Storage Refactoring

## Overview
Refactored vaccine storage from a nested `VaccineInfo` object to a flat array of vaccine names directly in `PawEntry`. This completely eliminates Firebase/Firestore issues with nested JSON structures.

## Problem
Firebase/Firestore was storing vaccines as a nested object:
```json
{
  "vaccine_info": {
    "vaccines": ["rabies", "distemper"]
  }
}
```
This creates unnecessary nesting and complexity. Firestore works best with flat structures.

## Solution
Removed the `VaccineInfo` object entirely and store vaccines as a direct `List<String>` field in `PawEntry`. Now it's saved as:
```json
{
  "vaccines": ["rabies", "distemper"]
}
```
Clean, flat, and Firestore-native.

## Changes Made

### 1. VaccineInfo Model (`lib/models/vaccine_info.dart`)
**Before:**
```dart
@freezed
class VaccineInfo with _$VaccineInfo {
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
}
```

**After:**
```dart
@freezed
class VaccineInfo with _$VaccineInfo {
  const factory VaccineInfo({
    @Default(<String>[]) List<String> vaccines,
  }) = _VaccineInfo;
}

// Added vaccine name constants
class VaccineNames {
  static const String rabies = 'rabies';
  static const String distemper = 'distemper';
  static const String hepatitis = 'hepatitis';
  static const String parvovirus = 'parvovirus';
  static const String bordetella = 'bordetella';
  static const String leptospirosis = 'leptospirosis';
  static const String panleukopenia = 'panleukopenia';
  static const String herpesvirusCalicivirus = 'herpesvirus_calicivirus';
}
```

### 2. NewPawUiModel (`lib/ui/features/new_paw/model/new_paw_ui_model.dart`)
**Before:**
```dart
factory NewPawUiModel({
  // ... other fields
  @Default(false) bool rabies_vaccine,
  @Default(false) bool distemper_vaccine,
  @Default(false) bool hepatitis_vaccine,
  @Default(false) bool parvovirus_vaccine,
  @Default(false) bool bordotella_vaccine,
  @Default(false) bool leptospirosis_vaccine,
  @Default(false) bool panleukopenia_vaccine,
  @Default(false) bool herpesvirus_and_calicivirus_vaccine,
}) = _NewPawUiModel;
```

**After:**
```dart
factory NewPawUiModel({
  // ... other fields
  @Default(<String>[]) List<String> vaccines,
}) = _NewPawUiModel;
```

### 3. Toggle Logic (`lib/ui/features/new_paw/logic/new_paw_logic.dart`)
**Before:**
```dart
void togglePawVaccine(Vaccines vaccines) {
  switch (vaccines) {
    case Vaccines.RABIES:
      state = state.copyWith(rabies_vaccine: !state.rabies_vaccine);
    // ... 7 more cases
  }
}
```

**After:**
```dart
void togglePawVaccine(Vaccines vaccines) {
  final String vaccineName = switch (vaccines) {
    Vaccines.RABIES => VaccineNames.rabies,
    Vaccines.DISTEMPER => VaccineNames.distemper,
    // ... map all enums to names
  };
  
  final List<String> currentVaccines = List.from(state.vaccines);
  if (currentVaccines.contains(vaccineName)) {
    currentVaccines.remove(vaccineName);
  } else {
    currentVaccines.add(vaccineName);
  }
  
  state = state.copyWith(vaccines: currentVaccines);
}
```

### 4. UI Updates
**Vaccine Selection UI (`lib/ui/features/new_paw/widgets/vaccine_create_body.dart`):**
```dart
// Before: isVaccineSelected: newPawUiModel.rabies_vaccine
// After:
isVaccineSelected: newPawUiModel.vaccines.contains(VaccineNames.rabies)
```

**Vaccine Detail Display (`lib/ui/features/detail/widgets/vaccine_body_detail.dart`):**
```dart
// Before: checking individual boolean fields
// After: checking array membership
int hasVaccine(String vaccineName) {
  if (pawEntryDetailResponse?.data?.vaccine_info?.vaccines == null) return 2;
  return pawEntryDetailResponse!.data!.vaccine_info!.vaccines.contains(vaccineName) ? 1 : 0;
}
```

### 5. Repository Simplification (`lib/data/network/paw_entry/paw_entry_repository.dart`)
**Before:**
```dart
// Complex handling to clean nested vaccine_info Map
if (data['vaccine_info'] != null) {
  Map<String, dynamic> vaccineData = Map<String, dynamic>.from(data['vaccine_info']);
  vaccineData.removeWhere((key, value) => value == null);
  data['vaccine_info'] = vaccineData;
}
```

**After:**
```dart
// Simple null removal - arrays don't need special handling
data.removeWhere((String key, dynamic value) => value == null);
```

## Benefits

1. **Firebase Compatibility**: Arrays are native Firestore types and don't cause nested JSON issues
2. **Simpler Code**: No need for special vaccine_info cleaning logic
3. **Better Performance**: Smaller data footprint (only stores selected vaccines)
4. **Type Safety**: Using string constants prevents typos
5. **Maintainability**: Single source of truth for vaccine names in `VaccineNames` class

## Testing
Updated test file to validate vaccine array serialization:
```dart
test('serializes VaccineInfo with vaccine array', () {
  PawEntry entry = PawEntry(
    id: 1,
    vaccine_info: const VaccineInfo(
      vaccines: [VaccineNames.rabies, VaccineNames.distemper]
    ),
  );
  // Validates that vaccines array is properly serialized
});
```

## Migration Notes
- Old paw entries in Firestore with boolean vaccine fields will need migration
- API consumers should be updated to handle the new array format
- The array only contains selected vaccines (empty array = no vaccines selected)

## Data Format Evolution

**Original (Problematic):**
```json
{
  "vaccine_info": {
    "rabies_vaccine": true,
    "distemper_vaccine": false,
    "hepatitis_vaccine": null,
    // ... 5 more nullable booleans
  }
}
```

**First Refactor (Still Nested):**
```json
{
  "vaccine_info": {
    "vaccines": ["rabies", "distemper"]
  }
}
```

**Final (Flat Structure):**
```json
{
  "vaccines": ["rabies", "distemper"]
}
```

## Files Modified

### Phase 1 (Original Refactor):
- `lib/models/vaccine_info.dart` - Model refactoring + constants
- `lib/ui/features/new_paw/model/new_paw_ui_model.dart` - UI model update  
- `lib/ui/features/new_paw/logic/new_paw_logic.dart` - Toggle logic + import
- `lib/ui/features/new_paw/widgets/vaccine_create_body.dart` - UI checks
- `lib/ui/features/detail/widgets/vaccine_body_detail.dart` - Detail view
- `lib/data/network/paw_entry/paw_entry_repository.dart` - Simplified cleaning

### Phase 2 (Flattening):
- `lib/models/paw_entry.dart` - Changed `VaccineInfo? vaccine_info` to `List<String> vaccines`
- `lib/models/paw_entry_detail.dart` - Updated `vaccinatedEnum` getter to use `vaccines.isNotEmpty`
- `lib/ui/features/new_paw/model/new_paw_ui_model.dart` - Removed VaccineInfo wrapping
- `lib/ui/features/detail/widgets/vaccine_body_detail.dart` - Access vaccines directly
- `test/models/paw_entry_to_json_test.dart` - Updated test for flat structure

### Files No Longer Needed:
- `lib/models/vaccine_info.dart` - Can be kept for `VaccineNames` constants but VaccineInfo class unused

## Date
December 2024 (Phase 1), October 2025 (Phase 2 - Flattening)
