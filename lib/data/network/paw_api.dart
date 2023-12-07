/// All Restclients that communicate with the Paw requests are defined here.
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../models/paw_entry.dart';
import 'paw_entry/paw_entry_rest_client.dart';

@injectable
class PawApi {
  PawApi(this._pawEntryRestClient);
  final PawEntryRestClient _pawEntryRestClient;

  Future<Either<String, PawEntry>> getPawEntry() async {
    try {
      final PawEntry pawEntry = await _pawEntryRestClient.getPawEntry();
      return right(pawEntry);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return left(e.toString());
    }
  }
}
