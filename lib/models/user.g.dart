// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  uid: json['uid'] as String,
  email: json['email'] as String?,
  emailVerified: json['emailVerified'] as bool? ?? false,
  displayName: json['displayName'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  photoUrl: json['photoUrl'] as String?,
  disabled: json['disabled'] as bool? ?? false,
  metadata: json['metadata'] == null
      ? null
      : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
  providerData: (json['providerData'] as List<dynamic>?)
      ?.map((e) => ProviderData.fromJson(e as Map<String, dynamic>))
      .toList(),
  mfaInfo: json['mfaInfo'],
  passwordHash: json['passwordHash'],
  passwordSalt: json['passwordSalt'],
  customClaims: json['customClaims'] as List<dynamic>?,
  tenantId: json['tenantId'],
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'emailVerified': instance.emailVerified,
  'displayName': instance.displayName,
  'phoneNumber': instance.phoneNumber,
  'photoUrl': instance.photoUrl,
  'disabled': instance.disabled,
  'metadata': instance.metadata?.toJson(),
  'providerData': instance.providerData?.map((e) => e.toJson()).toList(),
  'mfaInfo': instance.mfaInfo,
  'passwordHash': instance.passwordHash,
  'passwordSalt': instance.passwordSalt,
  'customClaims': instance.customClaims,
  'tenantId': instance.tenantId,
};
