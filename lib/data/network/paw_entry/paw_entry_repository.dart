import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../di/components/service_locator.dart';
import '../../../models/new_paw_model.dart';
import '../../../models/paw_entry.dart';
import '../../../models/paw_entry_detail.dart';
import '../paw_api.dart';

part 'paw_entry_repository.g.dart';

class PawEntryRepository {
  PawEntryRepository(this._pawApi);
  final PawApi _pawApi;

  Future<GetPawEntryResponse> getPawEntry() async {
    final GetPawEntryResponse pawEntry = await _pawApi.getPawEntry();
    return pawEntry;
  }

  Future<GetPawEntryResponse> getPawEntryById() async {
    final GetPawEntryResponse pawEntry = await _pawApi.getPawEntryById();
    return pawEntry;
  }

  Future<NewPawResponse> createPawEntry(NewPawModel newPawModel) async {
    final NewPawResponse pawEntry =
        await _pawApi.createPawEntry(newPawModel);
    return pawEntry;
  }

  Future<GetPawEntryDetailResponse> getPawEntryDetail(
      String classfieldsId) async {
    final GetPawEntryDetailResponse pawEntryDetail =
        await _pawApi.getPawEntryDetail(classfieldsId);
    return pawEntryDetail;
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
