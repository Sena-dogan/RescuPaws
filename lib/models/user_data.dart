import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'meta_data.dart';
import 'provider_data.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

@freezed
abstract class UserData with _$UserData {
  factory UserData({
    String? uid,
    String? email,
    bool? emailVerified,
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
    bool? disabled,
    Metadata? metadata,
    List<ProviderData>? providerData,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}

extension UserDataExtension on User {
  UserData toUserData() {
    return UserData(
      uid: uid,
      email: email,
      emailVerified: emailVerified,
      displayName: displayName,
      phoneNumber: phoneNumber,
      photoUrl: photoURL,
      disabled: false,
    );
  }
}
