// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nav_bar_logic.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(BottomNavBarLogic)
const bottomNavBarLogicProvider = BottomNavBarLogicProvider._();

final class BottomNavBarLogicProvider
    extends $NotifierProvider<BottomNavBarLogic, BottomNavBarUiModel> {
  const BottomNavBarLogicProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'bottomNavBarLogicProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$bottomNavBarLogicHash();

  @$internal
  @override
  BottomNavBarLogic create() => BottomNavBarLogic();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BottomNavBarUiModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BottomNavBarUiModel>(value),
    );
  }
}

String _$bottomNavBarLogicHash() => r'5ed095e9eafeeafcdbf972056dcfbc91751417cd';

abstract class _$BottomNavBarLogic extends $Notifier<BottomNavBarUiModel> {
  BottomNavBarUiModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BottomNavBarUiModel, BottomNavBarUiModel>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<BottomNavBarUiModel, BottomNavBarUiModel>,
        BottomNavBarUiModel,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
