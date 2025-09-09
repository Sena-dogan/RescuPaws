import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../constants/string_constants.dart';
import '../../../models/favorite/create_favorite_request.dart';
import '../../../models/favorite/create_favorite_response.dart';
import '../../../models/favorite/delete_favorite_response.dart';
import '../../../models/favorite/delete_favorites_request.dart';
import '../../../models/favorite/favorite_model.dart';
import '../../../models/paw_entry.dart';
import '../../../utils/firebase_utils.dart';

part 'favorite_repository.g.dart';

class FavoriteRepository {
  FavoriteRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<GetFavoriteListResponse> getFavoriteList() async {
    try {
      // Query with only one where clause to avoid any index requirements
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(StringsConsts.favoritesCollection)
          .where('uid', isEqualTo: currentUserUid)
          .get();

      final List<Favorite> favorites = <Favorite>[];
      
      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        final Map<String, dynamic> data = doc.data();
        
        // Get the classfield data from the classfields collection
        PawEntry? classfield;
        if (data['class_field_id'] != null) {
          try {
            final DocumentSnapshot<Map<String, dynamic>> classfieldDoc = await _firestore
                .collection('classfields')
                .doc(data['class_field_id'].toString())
                .get();
            
            if (classfieldDoc.exists) {
              classfield = PawEntry.fromJson(classfieldDoc.data()!);
            }
          } catch (e) {
            Logger().w('Error fetching classfield for favorite ${doc.id}: $e');
          }
        }
        
        final Favorite favorite = Favorite(
          id: data['id'] as int?,
          uid: data['uid'] as String?,
          class_field_id: data['class_field_id'] as int?,
          is_favorite: data['is_favorite'] as int?,
          created_at: data['created_at'] as String?,
          updated_at: data['updated_at'] as String?,
          classfield: classfield,
        );
        
        favorites.add(favorite);
      }

      // Sort by created_at in memory to avoid composite index requirement
      favorites.sort((Favorite a, Favorite b) {
        final DateTime? aDate = a.created_at != null ? DateTime.tryParse(a.created_at!) : null;
        final DateTime? bDate = b.created_at != null ? DateTime.tryParse(b.created_at!) : null;
        
        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        
        return bDate.compareTo(aDate); // Descending order (newest first)
      });

      Logger().i('favoriteList retrieved from Firebase: ${favorites.length} items');
      return GetFavoriteListResponse(data: favorites);
    } catch (e) {
      Logger().e('Error getting favorites from Firebase: $e');
      throw Exception('Failed to get favorites: $e');
    }
  }

  Future<CreateFavoriteResponse> createFavorite(CreateFavoriteRequest request) async {
    try {
      // Check if favorite already exists
      final QuerySnapshot<Map<String, dynamic>> existingFavorites = await _firestore
          .collection(StringsConsts.favoritesCollection)
          .where('uid', isEqualTo: request.uid)
          .where('class_field_id', isEqualTo: request.class_field_id)
          .limit(1)
          .get();

      final String now = DateTime.now().toIso8601String();
      final Map<String, dynamic> favoriteData = <String, dynamic>{
        'uid': request.uid,
        'class_field_id': request.class_field_id,
        'is_favorite': request.is_favorite,
        'created_at': now,
        'updated_at': now,
      };

      if (existingFavorites.docs.isNotEmpty) {
        // Update existing favorite
        final DocumentReference<Map<String, dynamic>> doc = existingFavorites.docs.first.reference;
        favoriteData['id'] = existingFavorites.docs.first.data()['id'];
        favoriteData['created_at'] = existingFavorites.docs.first.data()['created_at'];
        
        await doc.update(favoriteData);
        Logger().i('Favorite updated in Firebase');
      } else {
        // Create new favorite with auto-generated ID
        final DocumentReference<Map<String, dynamic>> docRef = await _firestore
            .collection(StringsConsts.favoritesCollection)
            .add(favoriteData);
        
        // Update with the document ID as the favorite ID
        await docRef.update(<Object, Object?>{'id': docRef.id.hashCode});
        Logger().i('Favorite created in Firebase');
      }

      return CreateFavoriteResponse(
        status: 'success',
        message: 'Favorite ${request.is_favorite == 1 ? 'added' : 'updated'} successfully',
      );
    } catch (e) {
      Logger().e('Error creating favorite in Firebase: $e');
      return CreateFavoriteResponse(
        status: 'error',
        message: e.toString(),
      );
    }
  }

  Future<DeleteFavoriteResponse> deleteFavorite(DeleteFavoriteRequest request) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(StringsConsts.favoritesCollection)
          .where('uid', isEqualTo: request.uid)
          .where('class_field_id', isEqualTo: request.class_field_id)
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
          await doc.reference.delete();
        }
        Logger().i('Favorite deleted from Firebase');
        return const DeleteFavoriteResponse(
          status: 'success',
          message: 'Favorite deleted successfully',
        );
      } else {
        return const DeleteFavoriteResponse(
          status: 'error',
          message: 'Favorite not found',
        );
      }
    } catch (e) {
      Logger().e('Error deleting favorite from Firebase: $e');
      return DeleteFavoriteResponse(
        status: 'error',
        message: e.toString(),
      );
    }
  }
}

@riverpod
FavoriteRepository getFavoriteRepository(Ref ref) {
  return FavoriteRepository();
}
