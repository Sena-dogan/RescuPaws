import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
// Import response DTO for creation API result
import 'package:rescupaws/models/new_paw_model.dart' show NewPawResponse;
import 'package:rescupaws/models/paw_entry.dart';
import 'package:rescupaws/models/paw_entry_detail.dart';
import 'package:rescupaws/utils/firebase_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paw_entry_repository.g.dart';

class PawEntryRepository {
  PawEntryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<Either<PawEntryError, GetPawEntryResponse>> getPawEntry() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snap = await _firestore
          .collection('classfields')
          .get();
      List<PawEntry> entries = snap.docs
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
      QuerySnapshot<Map<String, dynamic>> snap = await _firestore
          .collection('classfields')
          .where('user_id', isEqualTo: currentUserUid)
          .get();
      List<PawEntry> entries = snap.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> d) =>
              PawEntry.fromJson(d.data()))
          .toList();
      entries.sort((PawEntry a, PawEntry b) {
        DateTime? aDate = _parseCreatedAt(a.created_at);
        DateTime? bDate = _parseCreatedAt(b.created_at);
        if (aDate == null && bDate == null) {
          return 0;
        }
        if (aDate == null) {
          return 1;
        }
        if (bDate == null) {
          return -1;
        }
        return bDate.compareTo(aDate);
      });
      return right(GetPawEntryResponse(data: entries));
    } catch (e) {
      return left(PawEntryError(error: e.toString()));
    }
  }

  DateTime? _parseCreatedAt(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) {
      return null;
    }
    return DateTime.tryParse(timestamp);
  }

  Future<NewPawResponse> createPawEntry(PawEntry pawEntry) async {
    try {
      // Use provided id to keep consistency across app and Firebase doc id
      Map<String, dynamic> data = pawEntry.toJson();
      
      // Remove null values from top level - vaccine_info now uses arrays which don't need special handling
      data.removeWhere((String key, dynamic value) => value == null);
      
      // Handle advertiser_ref as DocumentReference
      if (pawEntry.user_id != null && pawEntry.user_id!.isNotEmpty) {
        data['advertiser_ref'] = _firestore
            .collection('users')
            .doc(pawEntry.user_id);
        // Remove user_id since we're using advertiser_ref
        data.remove('user_id');
      }
      
      // Remove fields that shouldn't be in Firestore or are internal
      data.remove('user'); // This is populated on read, not stored
      data.remove('selectedImageIndex'); // This is UI state, not stored
      
      debugPrint('Data to be saved: $data');
      
      await _firestore
          .collection('classfields')
          .doc(pawEntry.id.toString())
          .set(data);
      return NewPawResponse(status: 'success', message: 'Created', errors: null);
    } catch (e) {
      debugPrint('Error creating paw entry: $e');
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
        int parsed = int.tryParse(classfieldsId) ?? -1;
        QuerySnapshot<Map<String, dynamic>> snap = await _firestore
            .collection('classfields')
            .where('id', isEqualTo: parsed)
            .limit(1)
            .get();
        if (snap.docs.isNotEmpty) {
          doc = snap.docs.first;
        }
      }

      // Build mutable JSON and resolve advertiser reference if present
      Map<String, dynamic> json =
          Map<String, dynamic>.from(doc.data() ?? <String, dynamic>{});

      Object? advRefObj = json['advertiser_ref'];
      if (advRefObj is DocumentReference) {
        DocumentSnapshot<Map<String, dynamic>> advSnap =
            await advRefObj.get() as DocumentSnapshot<Map<String, dynamic>>;
        Map<String, dynamic>? adv = advSnap.data();
        if (adv != null) {
          // Attach under 'user' so UI can access data.user?.displayName
          json['user'] = adv;
          json['user_id'] ??= adv['uid'];
        }
      }

      PawEntry? detail =
          json.isEmpty ? null : PawEntry.fromJson(json);
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
@riverpod
PawEntryRepository getPawEntryRepository(Ref ref) {
  return PawEntryRepository();
}
