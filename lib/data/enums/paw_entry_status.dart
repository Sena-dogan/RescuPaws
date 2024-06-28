// ignore_for_file: non_constant_identifier_names

enum PawEntryStatus {
  approved(1),
  pending(0),
  rejected(2);

  const PawEntryStatus(this.value);
  final int value;

  static PawEntryStatus fromValue(int value) {
    switch (value) {
      case 0:
        return PawEntryStatus.pending;
      case 1:
        return PawEntryStatus.approved;
      case 2:
        return PawEntryStatus.rejected;
      default:
        throw Exception('Unknown value');
    }
  }



}
