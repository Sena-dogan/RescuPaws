/// All Restclients that communicate with the Paw requests are defined here.
import 'package:injectable/injectable.dart';

import '../../models/new_paw_model.dart';
import '../../models/paw_entry.dart';
import '../../utils/firebase_utils.dart';
import '../../models/paw_entry_detail.dart';
import 'paw_entry/paw_entry_rest_client.dart';

@injectable
class PawApi {
  PawApi(this._pawEntryRestClient);
  final PawEntryRestClient _pawEntryRestClient;

  Future<GetPawEntryResponse> getPawEntry() async {
    final GetPawEntryResponse pawEntry =
        await _pawEntryRestClient.getPawEntry();
    return pawEntry;
  }

  Future<GetPawEntryResponse> getPawEntryById() async {
    final String id = currentUserUid;
    final GetPawEntryResponse pawEntry =
        await _pawEntryRestClient.getPawEntryById(id);
    return pawEntry;
  }

  Future<NewPawResponse> createPawEntry(NewPawModel newPawModel) async {
    final NewPawResponse pawEntry =
        await _pawEntryRestClient.createPawEntry(newPawModel);
    return pawEntry;
  }

  Future<GetPawEntryDetailResponse> getPawEntryDetail(
      String classfieldsId) async {
    final GetPawEntryDetailResponse pawEntryDetail =
        await _pawEntryRestClient.getPawEntryDetail(classfieldsId);
    return pawEntryDetail;
  }
}
