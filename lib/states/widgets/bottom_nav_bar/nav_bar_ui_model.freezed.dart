// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nav_bar_ui_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BottomNavBarUiModel {
  int get navIndex;

  /// Create a copy of BottomNavBarUiModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BottomNavBarUiModelCopyWith<BottomNavBarUiModel> get copyWith =>
      _$BottomNavBarUiModelCopyWithImpl<BottomNavBarUiModel>(
          this as BottomNavBarUiModel, _$identity);

  /// Serializes this BottomNavBarUiModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BottomNavBarUiModel &&
            (identical(other.navIndex, navIndex) ||
                other.navIndex == navIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, navIndex);

  @override
  String toString() {
    return 'BottomNavBarUiModel(navIndex: $navIndex)';
  }
}

/// @nodoc
abstract mixin class $BottomNavBarUiModelCopyWith<$Res> {
  factory $BottomNavBarUiModelCopyWith(
          BottomNavBarUiModel value, $Res Function(BottomNavBarUiModel) _then) =
      _$BottomNavBarUiModelCopyWithImpl;
  @useResult
  $Res call({int navIndex});
}

/// @nodoc
class _$BottomNavBarUiModelCopyWithImpl<$Res>
    implements $BottomNavBarUiModelCopyWith<$Res> {
  _$BottomNavBarUiModelCopyWithImpl(this._self, this._then);

  final BottomNavBarUiModel _self;
  final $Res Function(BottomNavBarUiModel) _then;

  /// Create a copy of BottomNavBarUiModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? navIndex = null,
  }) {
    return _then(_self.copyWith(
      navIndex: null == navIndex
          ? _self.navIndex
          : navIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [BottomNavBarUiModel].
extension BottomNavBarUiModelPatterns on BottomNavBarUiModel {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BottomNavBarUiModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BottomNavBarUiModel() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BottomNavBarUiModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BottomNavBarUiModel():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BottomNavBarUiModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BottomNavBarUiModel() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int navIndex)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BottomNavBarUiModel() when $default != null:
        return $default(_that.navIndex);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int navIndex) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BottomNavBarUiModel():
        return $default(_that.navIndex);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int navIndex)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BottomNavBarUiModel() when $default != null:
        return $default(_that.navIndex);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BottomNavBarUiModel implements BottomNavBarUiModel {
  const _BottomNavBarUiModel({this.navIndex = 0});
  factory _BottomNavBarUiModel.fromJson(Map<String, dynamic> json) =>
      _$BottomNavBarUiModelFromJson(json);

  @override
  @JsonKey()
  final int navIndex;

  /// Create a copy of BottomNavBarUiModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BottomNavBarUiModelCopyWith<_BottomNavBarUiModel> get copyWith =>
      __$BottomNavBarUiModelCopyWithImpl<_BottomNavBarUiModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BottomNavBarUiModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BottomNavBarUiModel &&
            (identical(other.navIndex, navIndex) ||
                other.navIndex == navIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, navIndex);

  @override
  String toString() {
    return 'BottomNavBarUiModel(navIndex: $navIndex)';
  }
}

/// @nodoc
abstract mixin class _$BottomNavBarUiModelCopyWith<$Res>
    implements $BottomNavBarUiModelCopyWith<$Res> {
  factory _$BottomNavBarUiModelCopyWith(_BottomNavBarUiModel value,
          $Res Function(_BottomNavBarUiModel) _then) =
      __$BottomNavBarUiModelCopyWithImpl;
  @override
  @useResult
  $Res call({int navIndex});
}

/// @nodoc
class __$BottomNavBarUiModelCopyWithImpl<$Res>
    implements _$BottomNavBarUiModelCopyWith<$Res> {
  __$BottomNavBarUiModelCopyWithImpl(this._self, this._then);

  final _BottomNavBarUiModel _self;
  final $Res Function(_BottomNavBarUiModel) _then;

  /// Create a copy of BottomNavBarUiModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? navIndex = null,
  }) {
    return _then(_BottomNavBarUiModel(
      navIndex: null == navIndex
          ? _self.navIndex
          : navIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
