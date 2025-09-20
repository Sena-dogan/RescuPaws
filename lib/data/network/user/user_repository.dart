import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../constants/string_constants.dart';
import '../../../models/user_data.dart';

part 'user_repository.g.dart';

@riverpod
UserData currentUser(Ref ref) =>
    FirebaseAuth.instance.currentUser!.toUserData();

class UserRepository {
  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Upsert the currently authenticated Firebase user into Firestore 'users/{uid}'.
  Future<void> upsertCurrentUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await upsertUser(user.toUserData());
  }

  /// Upsert any user data into 'users/{uid}'.
  Future<void> upsertUser(UserData user) async {
    if (user.uid == null) return;
    final Map<String, dynamic> json = user.toJson()..removeWhere((String key, dynamic value) => value == null);

    await _firestore
        .collection(StringsConsts.usersCollection)
        .doc(user.uid)
        // Merge to avoid overwriting existing subcollections like chats
        .set(json, SetOptions(merge: true));
  }
}

@riverpod
UserRepository getUserRepository(Ref ref) {
  return UserRepository();
}
