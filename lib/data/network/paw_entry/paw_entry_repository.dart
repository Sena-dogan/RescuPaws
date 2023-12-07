import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../di/components/service_locator.dart';
import '../../../models/paw_entry.dart';
import '../paw_api.dart';

part 'paw_entry_repository.g.dart';

class PawEntryRepository {
  PawEntryRepository(this._pawApi);
  final PawApi _pawApi;

  Future<Either<String, PawEntry>> getPawEntry() async {
    // Best part of functional programming: no try-catch blocks!
    // Instead, we use Either to return either a String or a PawEntry.
    // If the request fails, we return a String with the error message.
    // If the request succeeds, we return a PawEntry.
    final Either<String, PawEntry> pawEntry = await _pawApi.getPawEntry();
    return pawEntry;
  }
}

// This is the Riverpod way of injecting dependencies.
/// Returns an instance of [PawEntryRepository] using the provided [GetPawEntryRepositoryRef].
///
/// The [PawEntryRepository] is initialized with an instance of [PawApi] obtained from [getIt].
/// Simply what getIt does is that it returns an instance of [PawApi] that is already initialized with [PawEntryRestClient].
/// [PawEntryRestClient] is initialized with [Dio] and [Endpoints.baseUrl].
@riverpod
PawEntryRepository getPawEntryRepository(GetPawEntryRepositoryRef ref) {
  final PawApi pawApi = getIt<PawApi>();
  return PawEntryRepository(pawApi);
}
