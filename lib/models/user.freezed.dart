// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 String get uid; String? get email; bool get emailVerified; String? get displayName; String? get phoneNumber; String? get photoUrl; bool get disabled; Metadata? get metadata; List<ProviderData>? get providerData; dynamic get mfaInfo; dynamic get passwordHash; dynamic get passwordSalt; List<dynamic>? get customClaims; dynamic get tenantId;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.disabled, disabled) || other.disabled == disabled)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&const DeepCollectionEquality().equals(other.providerData, providerData)&&const DeepCollectionEquality().equals(other.mfaInfo, mfaInfo)&&const DeepCollectionEquality().equals(other.passwordHash, passwordHash)&&const DeepCollectionEquality().equals(other.passwordSalt, passwordSalt)&&const DeepCollectionEquality().equals(other.customClaims, customClaims)&&const DeepCollectionEquality().equals(other.tenantId, tenantId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,emailVerified,displayName,phoneNumber,photoUrl,disabled,metadata,const DeepCollectionEquality().hash(providerData),const DeepCollectionEquality().hash(mfaInfo),const DeepCollectionEquality().hash(passwordHash),const DeepCollectionEquality().hash(passwordSalt),const DeepCollectionEquality().hash(customClaims),const DeepCollectionEquality().hash(tenantId));

@override
String toString() {
  return 'User(uid: $uid, email: $email, emailVerified: $emailVerified, displayName: $displayName, phoneNumber: $phoneNumber, photoUrl: $photoUrl, disabled: $disabled, metadata: $metadata, providerData: $providerData, mfaInfo: $mfaInfo, passwordHash: $passwordHash, passwordSalt: $passwordSalt, customClaims: $customClaims, tenantId: $tenantId)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String uid, String? email, bool emailVerified, String? displayName, String? phoneNumber, String? photoUrl, bool disabled, Metadata? metadata, List<ProviderData>? providerData, dynamic mfaInfo, dynamic passwordHash, dynamic passwordSalt, List<dynamic>? customClaims, dynamic tenantId
});


$MetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = freezed,Object? emailVerified = null,Object? displayName = freezed,Object? phoneNumber = freezed,Object? photoUrl = freezed,Object? disabled = null,Object? metadata = freezed,Object? providerData = freezed,Object? mfaInfo = freezed,Object? passwordHash = freezed,Object? passwordSalt = freezed,Object? customClaims = freezed,Object? tenantId = freezed,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,disabled: null == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Metadata?,providerData: freezed == providerData ? _self.providerData : providerData // ignore: cast_nullable_to_non_nullable
as List<ProviderData>?,mfaInfo: freezed == mfaInfo ? _self.mfaInfo : mfaInfo // ignore: cast_nullable_to_non_nullable
as dynamic,passwordHash: freezed == passwordHash ? _self.passwordHash : passwordHash // ignore: cast_nullable_to_non_nullable
as dynamic,passwordSalt: freezed == passwordSalt ? _self.passwordSalt : passwordSalt // ignore: cast_nullable_to_non_nullable
as dynamic,customClaims: freezed == customClaims ? _self.customClaims : customClaims // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,tenantId: freezed == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $MetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String? email,  bool emailVerified,  String? displayName,  String? phoneNumber,  String? photoUrl,  bool disabled,  Metadata? metadata,  List<ProviderData>? providerData,  dynamic mfaInfo,  dynamic passwordHash,  dynamic passwordSalt,  List<dynamic>? customClaims,  dynamic tenantId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.uid,_that.email,_that.emailVerified,_that.displayName,_that.phoneNumber,_that.photoUrl,_that.disabled,_that.metadata,_that.providerData,_that.mfaInfo,_that.passwordHash,_that.passwordSalt,_that.customClaims,_that.tenantId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String? email,  bool emailVerified,  String? displayName,  String? phoneNumber,  String? photoUrl,  bool disabled,  Metadata? metadata,  List<ProviderData>? providerData,  dynamic mfaInfo,  dynamic passwordHash,  dynamic passwordSalt,  List<dynamic>? customClaims,  dynamic tenantId)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.uid,_that.email,_that.emailVerified,_that.displayName,_that.phoneNumber,_that.photoUrl,_that.disabled,_that.metadata,_that.providerData,_that.mfaInfo,_that.passwordHash,_that.passwordSalt,_that.customClaims,_that.tenantId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String? email,  bool emailVerified,  String? displayName,  String? phoneNumber,  String? photoUrl,  bool disabled,  Metadata? metadata,  List<ProviderData>? providerData,  dynamic mfaInfo,  dynamic passwordHash,  dynamic passwordSalt,  List<dynamic>? customClaims,  dynamic tenantId)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.uid,_that.email,_that.emailVerified,_that.displayName,_that.phoneNumber,_that.photoUrl,_that.disabled,_that.metadata,_that.providerData,_that.mfaInfo,_that.passwordHash,_that.passwordSalt,_that.customClaims,_that.tenantId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
   _User({required this.uid, this.email, this.emailVerified = false, this.displayName, this.phoneNumber, this.photoUrl, this.disabled = false, this.metadata, final  List<ProviderData>? providerData, this.mfaInfo, this.passwordHash, this.passwordSalt, final  List<dynamic>? customClaims, this.tenantId}): _providerData = providerData,_customClaims = customClaims;
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  String uid;
@override final  String? email;
@override@JsonKey() final  bool emailVerified;
@override final  String? displayName;
@override final  String? phoneNumber;
@override final  String? photoUrl;
@override@JsonKey() final  bool disabled;
@override final  Metadata? metadata;
 final  List<ProviderData>? _providerData;
@override List<ProviderData>? get providerData {
  final value = _providerData;
  if (value == null) return null;
  if (_providerData is EqualUnmodifiableListView) return _providerData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  dynamic mfaInfo;
@override final  dynamic passwordHash;
@override final  dynamic passwordSalt;
 final  List<dynamic>? _customClaims;
@override List<dynamic>? get customClaims {
  final value = _customClaims;
  if (value == null) return null;
  if (_customClaims is EqualUnmodifiableListView) return _customClaims;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  dynamic tenantId;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.disabled, disabled) || other.disabled == disabled)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&const DeepCollectionEquality().equals(other._providerData, _providerData)&&const DeepCollectionEquality().equals(other.mfaInfo, mfaInfo)&&const DeepCollectionEquality().equals(other.passwordHash, passwordHash)&&const DeepCollectionEquality().equals(other.passwordSalt, passwordSalt)&&const DeepCollectionEquality().equals(other._customClaims, _customClaims)&&const DeepCollectionEquality().equals(other.tenantId, tenantId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,emailVerified,displayName,phoneNumber,photoUrl,disabled,metadata,const DeepCollectionEquality().hash(_providerData),const DeepCollectionEquality().hash(mfaInfo),const DeepCollectionEquality().hash(passwordHash),const DeepCollectionEquality().hash(passwordSalt),const DeepCollectionEquality().hash(_customClaims),const DeepCollectionEquality().hash(tenantId));

@override
String toString() {
  return 'User(uid: $uid, email: $email, emailVerified: $emailVerified, displayName: $displayName, phoneNumber: $phoneNumber, photoUrl: $photoUrl, disabled: $disabled, metadata: $metadata, providerData: $providerData, mfaInfo: $mfaInfo, passwordHash: $passwordHash, passwordSalt: $passwordSalt, customClaims: $customClaims, tenantId: $tenantId)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String uid, String? email, bool emailVerified, String? displayName, String? phoneNumber, String? photoUrl, bool disabled, Metadata? metadata, List<ProviderData>? providerData, dynamic mfaInfo, dynamic passwordHash, dynamic passwordSalt, List<dynamic>? customClaims, dynamic tenantId
});


@override $MetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = freezed,Object? emailVerified = null,Object? displayName = freezed,Object? phoneNumber = freezed,Object? photoUrl = freezed,Object? disabled = null,Object? metadata = freezed,Object? providerData = freezed,Object? mfaInfo = freezed,Object? passwordHash = freezed,Object? passwordSalt = freezed,Object? customClaims = freezed,Object? tenantId = freezed,}) {
  return _then(_User(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,disabled: null == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Metadata?,providerData: freezed == providerData ? _self._providerData : providerData // ignore: cast_nullable_to_non_nullable
as List<ProviderData>?,mfaInfo: freezed == mfaInfo ? _self.mfaInfo : mfaInfo // ignore: cast_nullable_to_non_nullable
as dynamic,passwordHash: freezed == passwordHash ? _self.passwordHash : passwordHash // ignore: cast_nullable_to_non_nullable
as dynamic,passwordSalt: freezed == passwordSalt ? _self.passwordSalt : passwordSalt // ignore: cast_nullable_to_non_nullable
as dynamic,customClaims: freezed == customClaims ? _self._customClaims : customClaims // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,tenantId: freezed == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $MetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
