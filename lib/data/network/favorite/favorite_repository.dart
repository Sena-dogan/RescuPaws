import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:rescupaws/constants/string_constants.dart';
import 'package:rescupaws/models/favorite/create_favorite_request.dart';
import 'package:rescupaws/models/favorite/create_favorite_response.dart';
import 'package:rescupaws/models/favorite/delete_favorite_response.dart';
import 'package:rescupaws/models/favorite/delete_favorites_request.dart';
import 'package:rescupaws/models/favorite/favorite_model.dart';
import 'package:rescupaws/models/paw_entry.dart';
import 'package:rescupaws/utils/firebase_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_repository.g.dart';

class FavoriteRepository {
  FavoriteRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<GetFavoriteListResponse> getFavoriteList() async {
    try {
      // Query with only one where clause to avoid any index requirements
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(StringsConsts.favoritesCollection)
          .where('uid', isEqualTo: currentUserUid)
          .get();

      List<Favorite> favorites = <Favorite>[];
      
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();
        
        // Get the classfield data from the classfields collection
        PawEntry? classfield;
        if (data['class_field_id'] != null) {
          try {
            DocumentSnapshot<Map<String, dynamic>> classfieldDoc = await _firestore
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
        
        Favorite favorite = Favorite(
          id: data['id'] as int?,
          uid: data['uid'] as String?,
          classFieldId: data['class_field_id'] as int?,
          isFavorite: data['is_favorite'] as int?,
          createdAt: data['created_at'] as String?,
          updatedAt: data['updated_at'] as String?,
          classfield: classfield,
        );
        
        favorites.add(favorite);
      }

      // Sort by created_at in memory to avoid composite index requirement
      favorites.sort((Favorite a, Favorite b) {
        DateTime? aDate = a.createdAt != null ? DateTime.tryParse(a.createdAt!) : null;
        DateTime? bDate = b.createdAt != null ? DateTime.tryParse(b.createdAt!) : null;
        
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
      QuerySnapshot<Map<String, dynamic>> existingFavorites = await _firestore
          .collection(StringsConsts.favoritesCollection)
          .where('uid', isEqualTo: request.uid)
          .where('class_field_id', isEqualTo: request.classFieldId)
          .limit(1)
          .get();

      String now = DateTime.now().toIso8601String();
      Map<String, dynamic> favoriteData = <String, dynamic>{
        'uid': request.uid,
        'class_field_id': request.classFieldId,
        'is_favorite': request.isFavorite,
        'created_at': now,
        'updated_at': now,
      };

      if (existingFavorites.docs.isNotEmpty) {
        // Update existing favorite
        DocumentReference<Map<String, dynamic>> doc = existingFavorites.docs.first.reference;
        favoriteData['id'] = existingFavorites.docs.first.data()['id'];
        favoriteData['created_at'] = existingFavorites.docs.first.data()['created_at'];
        
        await doc.update(favoriteData);
        Logger().i('Favorite updated in Firebase');
      } else {
        // Create new favorite with auto-generated ID
        DocumentReference<Map<String, dynamic>> docRef = await _firestore
            .collection(StringsConsts.favoritesCollection)
            .add(favoriteData);
        
        // Update with the document ID as the favorite ID
        await docRef.update(<Object, Object?>{'id': docRef.id.hashCode});
        Logger().i('Favorite created in Firebase');
      }

      return CreateFavoriteResponse(
        status: 'success',
        message: 'Favorite ${request.isFavorite == 1 ? 'added' : 'updated'} successfully',
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
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(StringsConsts.favoritesCollection)
          .where('uid', isEqualTo: request.uid)
          .where('class_field_id', isEqualTo: request.classFieldId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
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
