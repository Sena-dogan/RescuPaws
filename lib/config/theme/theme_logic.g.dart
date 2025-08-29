// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_logic.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ThemeLogic)
const themeLogicProvider = ThemeLogicProvider._();

final class ThemeLogicProvider
    extends $NotifierProvider<ThemeLogic, ThemeUiModel> {
  const ThemeLogicProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'themeLogicProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$themeLogicHash();

  @$internal
  @override
  ThemeLogic create() => ThemeLogic();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeUiModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeUiModel>(value),
    );
  }
}

String _$themeLogicHash() => r'c8cd24aa26927d483e43b95be091bd6332d6b647';

abstract class _$ThemeLogic extends $Notifier<ThemeUiModel> {
  ThemeUiModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ThemeUiModel, ThemeUiModel>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ThemeUiModel, ThemeUiModel>,
        ThemeUiModel,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
