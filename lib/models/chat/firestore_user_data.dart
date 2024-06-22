import 'package:freezed_annotation/freezed_annotation.dart';

part 'firestore_user_data.freezed.dart';
part 'firestore_user_data.g.dart';

@freezed
class FirestoreUserData with _$FirestoreUserData {
  factory FirestoreUserData({
    String? uid,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
  }) = _FirestoreUserData;

  factory FirestoreUserData.fromJson(Map<String, dynamic> json) =>
      _$FirestoreUserDataFromJson(json);
}
