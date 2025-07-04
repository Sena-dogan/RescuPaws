// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get uid => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  bool get emailVerified => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  bool get disabled => throw _privateConstructorUsedError;
  Metadata? get metadata => throw _privateConstructorUsedError;
  List<ProviderData>? get providerData => throw _privateConstructorUsedError;
  dynamic get mfaInfo => throw _privateConstructorUsedError;
  dynamic get passwordHash => throw _privateConstructorUsedError;
  dynamic get passwordSalt => throw _privateConstructorUsedError;
  List<dynamic>? get customClaims => throw _privateConstructorUsedError;
  dynamic get tenantId => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String uid,
      String? email,
      bool emailVerified,
      String? displayName,
      String? phoneNumber,
      String? photoUrl,
      bool disabled,
      Metadata? metadata,
      List<ProviderData>? providerData,
      dynamic mfaInfo,
      dynamic passwordHash,
      dynamic passwordSalt,
      List<dynamic>? customClaims,
      dynamic tenantId});

  $MetadataCopyWith<$Res>? get metadata;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = freezed,
    Object? emailVerified = null,
    Object? displayName = freezed,
    Object? phoneNumber = freezed,
    Object? photoUrl = freezed,
    Object? disabled = null,
    Object? metadata = freezed,
    Object? providerData = freezed,
    Object? mfaInfo = freezed,
    Object? passwordHash = freezed,
    Object? passwordSalt = freezed,
    Object? customClaims = freezed,
    Object? tenantId = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      disabled: null == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Metadata?,
      providerData: freezed == providerData
          ? _value.providerData
          : providerData // ignore: cast_nullable_to_non_nullable
              as List<ProviderData>?,
      mfaInfo: freezed == mfaInfo
          ? _value.mfaInfo
          : mfaInfo // ignore: cast_nullable_to_non_nullable
              as dynamic,
      passwordHash: freezed == passwordHash
          ? _value.passwordHash
          : passwordHash // ignore: cast_nullable_to_non_nullable
              as dynamic,
      passwordSalt: freezed == passwordSalt
          ? _value.passwordSalt
          : passwordSalt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      customClaims: freezed == customClaims
          ? _value.customClaims
          : customClaims // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      tenantId: freezed == tenantId
          ? _value.tenantId
          : tenantId // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetadataCopyWith<$Res>? get metadata {
    if (_value.metadata == null) {
      return null;
    }

    return $MetadataCopyWith<$Res>(_value.metadata!, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String? email,
      bool emailVerified,
      String? displayName,
      String? phoneNumber,
      String? photoUrl,
      bool disabled,
      Metadata? metadata,
      List<ProviderData>? providerData,
      dynamic mfaInfo,
      dynamic passwordHash,
      dynamic passwordSalt,
      List<dynamic>? customClaims,
      dynamic tenantId});

  @override
  $MetadataCopyWith<$Res>? get metadata;
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = freezed,
    Object? emailVerified = null,
    Object? displayName = freezed,
    Object? phoneNumber = freezed,
    Object? photoUrl = freezed,
    Object? disabled = null,
    Object? metadata = freezed,
    Object? providerData = freezed,
    Object? mfaInfo = freezed,
    Object? passwordHash = freezed,
    Object? passwordSalt = freezed,
    Object? customClaims = freezed,
    Object? tenantId = freezed,
  }) {
    return _then(_$UserImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      disabled: null == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Metadata?,
      providerData: freezed == providerData
          ? _value._providerData
          : providerData // ignore: cast_nullable_to_non_nullable
              as List<ProviderData>?,
      mfaInfo: freezed == mfaInfo
          ? _value.mfaInfo
          : mfaInfo // ignore: cast_nullable_to_non_nullable
              as dynamic,
      passwordHash: freezed == passwordHash
          ? _value.passwordHash
          : passwordHash // ignore: cast_nullable_to_non_nullable
              as dynamic,
      passwordSalt: freezed == passwordSalt
          ? _value.passwordSalt
          : passwordSalt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      customClaims: freezed == customClaims
          ? _value._customClaims
          : customClaims // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      tenantId: freezed == tenantId
          ? _value.tenantId
          : tenantId // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  _$UserImpl(
      {required this.uid,
      this.email,
      this.emailVerified = false,
      this.displayName,
      this.phoneNumber,
      this.photoUrl,
      this.disabled = false,
      this.metadata,
      final List<ProviderData>? providerData,
      this.mfaInfo,
      this.passwordHash,
      this.passwordSalt,
      final List<dynamic>? customClaims,
      this.tenantId})
      : _providerData = providerData,
        _customClaims = customClaims;

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String uid;
  @override
  final String? email;
  @override
  @JsonKey()
  final bool emailVerified;
  @override
  final String? displayName;
  @override
  final String? phoneNumber;
  @override
  final String? photoUrl;
  @override
  @JsonKey()
  final bool disabled;
  @override
  final Metadata? metadata;
  final List<ProviderData>? _providerData;
  @override
  List<ProviderData>? get providerData {
    final value = _providerData;
    if (value == null) return null;
    if (_providerData is EqualUnmodifiableListView) return _providerData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final dynamic mfaInfo;
  @override
  final dynamic passwordHash;
  @override
  final dynamic passwordSalt;
  final List<dynamic>? _customClaims;
  @override
  List<dynamic>? get customClaims {
    final value = _customClaims;
    if (value == null) return null;
    if (_customClaims is EqualUnmodifiableListView) return _customClaims;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final dynamic tenantId;

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, emailVerified: $emailVerified, displayName: $displayName, phoneNumber: $phoneNumber, photoUrl: $photoUrl, disabled: $disabled, metadata: $metadata, providerData: $providerData, mfaInfo: $mfaInfo, passwordHash: $passwordHash, passwordSalt: $passwordSalt, customClaims: $customClaims, tenantId: $tenantId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata) &&
            const DeepCollectionEquality()
                .equals(other._providerData, _providerData) &&
            const DeepCollectionEquality().equals(other.mfaInfo, mfaInfo) &&
            const DeepCollectionEquality()
                .equals(other.passwordHash, passwordHash) &&
            const DeepCollectionEquality()
                .equals(other.passwordSalt, passwordSalt) &&
            const DeepCollectionEquality()
                .equals(other._customClaims, _customClaims) &&
            const DeepCollectionEquality().equals(other.tenantId, tenantId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      email,
      emailVerified,
      displayName,
      phoneNumber,
      photoUrl,
      disabled,
      metadata,
      const DeepCollectionEquality().hash(_providerData),
      const DeepCollectionEquality().hash(mfaInfo),
      const DeepCollectionEquality().hash(passwordHash),
      const DeepCollectionEquality().hash(passwordSalt),
      const DeepCollectionEquality().hash(_customClaims),
      const DeepCollectionEquality().hash(tenantId));

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  factory _User(
      {required final String uid,
      final String? email,
      final bool emailVerified,
      final String? displayName,
      final String? phoneNumber,
      final String? photoUrl,
      final bool disabled,
      final Metadata? metadata,
      final List<ProviderData>? providerData,
      final dynamic mfaInfo,
      final dynamic passwordHash,
      final dynamic passwordSalt,
      final List<dynamic>? customClaims,
      final dynamic tenantId}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get uid;
  @override
  String? get email;
  @override
  bool get emailVerified;
  @override
  String? get displayName;
  @override
  String? get phoneNumber;
  @override
  String? get photoUrl;
  @override
  bool get disabled;
  @override
  Metadata? get metadata;
  @override
  List<ProviderData>? get providerData;
  @override
  dynamic get mfaInfo;
  @override
  dynamic get passwordHash;
  @override
  dynamic get passwordSalt;
  @override
  List<dynamic>? get customClaims;
  @override
  dynamic get tenantId;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
