// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'meta_data.dart';
import 'provider_data.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  factory User({
    required String uid,
    String? email,
    @Default(false) bool emailVerified,
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
    @Default(false) bool disabled,
    Metadata? metadata,
    List<ProviderData>? providerData,
    dynamic mfaInfo,
    dynamic passwordHash,
    dynamic passwordSalt,
    List<dynamic>? customClaims,
    dynamic tenantId,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
