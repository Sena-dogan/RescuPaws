import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/new_paw_model.dart';
import '../../../models/paw_entry.dart';
import '../../../models/paw_entry_detail.dart';
import '../../../utils/firebase_utils.dart';

part 'paw_entry_repository.g.dart';

class PawEntryRepository {
  PawEntryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<Either<PawEntryError, GetPawEntryResponse>> getPawEntry() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap = await _firestore
          .collection('classfields')
          .orderBy('created_at', descending: true)
          .get();
      final List<PawEntry> entries = snap.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> d) =>
              PawEntry.fromJson(d.data()))
          .toList();
      return right(GetPawEntryResponse(data: entries));
    } catch (e) {
      return left(PawEntryError(error: e.toString()));
    }
  }

  Future<Either<PawEntryError, GetPawEntryResponse>> getPawEntryById() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap = await _firestore
          .collection('classfields')
          .where('user_id', isEqualTo: currentUserUid)
          .orderBy('created_at', descending: true)
          .get();
      final List<PawEntry> entries = snap.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> d) =>
              PawEntry.fromJson(d.data()))
          .toList();
      return right(GetPawEntryResponse(data: entries));
    } catch (e) {
      return left(PawEntryError(error: e.toString()));
    }
  }

  Future<NewPawResponse> createPawEntry(NewPawModel newPawModel) async {
    try {
      // Create a numeric ID (milliseconds) to satisfy model requirements
      final int id = DateTime.now().millisecondsSinceEpoch;
      final Map<String, dynamic> data = <String, dynamic>{
        'id': id,
        'user_id': newPawModel.user_id ?? currentUserUid,
        'name': newPawModel.name,
        'description': newPawModel.description,
        'category_id': newPawModel.category_id,
        'country_id': newPawModel.country_id,
        'city_id': newPawModel.city_id,
        'district_id': newPawModel.district_id,
        'gender': newPawModel.gender,
        'age': newPawModel.age,
        'education': newPawModel.education,
        'weight': newPawModel.weight,
        'address': newPawModel.address,
        // Keep original images list; UI tolerates empty images_uploads
        'image': newPawModel.image,
        // backend fields typically present
        'status': 0,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _firestore.collection('classfields').doc(id.toString()).set(data);
      return NewPawResponse(status: 'success', message: 'Created', errors: null);
    } catch (e) {
      return NewPawResponse(status: 'error', message: e.toString(), errors: <String, dynamic>{});
    }
  }

  Future<GetPawEntryDetailResponse> getPawEntryDetail(
      String classfieldsId) async {
    // Try direct doc id first, then fallback to query by field 'id'
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('classfields')
          .doc(classfieldsId)
          .get();
      if (!doc.exists) {
        final int parsed = int.tryParse(classfieldsId) ?? -1;
        final QuerySnapshot<Map<String, dynamic>> snap = await _firestore
            .collection('classfields')
            .where('id', isEqualTo: parsed)
            .limit(1)
            .get();
        if (snap.docs.isNotEmpty) {
          doc = snap.docs.first;
        }
      }

      final Map<String, dynamic>? json = doc.data();
      final PawEntryDetail? detail =
          json == null ? null : PawEntryDetail.fromJson(json);
      return GetPawEntryDetailResponse(
        data: detail,
      );
    } catch (e) {
      // Surface minimal info on error
      throw Exception('Failed to load classfields detail: $e');
    }
  }
}

// This is the Riverpod way of injecting dependencies.
/// Returns an instance of [PawEntryRepository] using the provided [Ref].
///
/// The [PawEntryRepository] is initialized with an instance of [PawApi] obtained from [getIt].
/// Simply what getIt does is that it returns an instance of [PawApi] that is already initialized with [PawEntryRestClient].
/// [PawEntryRestClient] is initialized with [Dio] and [Endpoints.baseUrl].
@riverpod
PawEntryRepository getPawEntryRepository(Ref ref) {
  return PawEntryRepository();
}
