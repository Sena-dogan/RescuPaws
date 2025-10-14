import 'package:flutter_test/flutter_test.dart';
import 'package:rescupaws/models/paw_entry.dart';
import 'package:rescupaws/models/vaccine_info.dart';

void main() {
  group('PawEntry.toJson', () {
    test('serializes vaccines as a direct array', () {
      PawEntry entry = PawEntry(
        id: 1,
        vaccines: <String>[VaccineNames.rabies, VaccineNames.distemper],
      );

      Map<String, dynamic> json = entry.toJson();

      expect(json['vaccines'], isA<List<dynamic>>());
      expect(json['vaccines'], contains(VaccineNames.rabies));
      expect(json['vaccines'], contains(VaccineNames.distemper));
      expect(json['vaccines'].length, equals(2));
    });
  });
}
