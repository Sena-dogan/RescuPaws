// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:get_storage/get_storage.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/getstore/get_store_helper.dart' as _i4;
import '../../data/network/auth/auth_rest_client.dart' as _i10;
import '../../data/network/auth_api.dart' as _i16;
import '../../data/network/category/category_rest_client.dart' as _i11;
import '../../data/network/category_api.dart' as _i17;
import '../../data/network/favorite/favorite_rest_client.dart' as _i6;
import '../../data/network/favorite_api.dart' as _i12;
import '../../data/network/location/location_rest_client.dart' as _i7;
import '../../data/network/location_api.dart' as _i13;
import '../../data/network/paw_api.dart' as _i14;
import '../../data/network/paw_entry/paw_entry_rest_client.dart' as _i8;
import '../../data/network/utils/utils_rest_client.dart' as _i9;
import '../../data/network/utils_api.dart' as _i15;
import '../module/network_module.dart' as _i18;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    await gh.factoryAsync<_i3.GetStorage>(
      () => networkModule.provideGetStorage(),
      preResolve: true,
    );
    gh.factory<_i4.GetStoreHelper>(
        () => _i4.GetStoreHelper(gh<_i3.GetStorage>()));
    await gh.factoryAsync<_i5.Dio>(
      () => networkModule.provideDio(gh<_i4.GetStoreHelper>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i6.FavoriteRestClient>(
      () => networkModule.provideFavoriteRestClient(gh<_i5.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i7.LocationRestClient>(
      () => networkModule.provideLocationRestClient(gh<_i5.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i8.PawEntryRestClient>(
      () => networkModule.providePawEntryRestClient(gh<_i5.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i9.UtilsRestClient>(
      () => networkModule.provideUtilsRestClient(gh<_i5.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i10.AuthRestClient>(
      () => networkModule.provideAuthRestClient(gh<_i5.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i11.CategoryRestClient>(
      () => networkModule.provideCategoryRestClient(gh<_i5.Dio>()),
      preResolve: true,
    );
    gh.factory<_i12.FavoriteApi>(
        () => _i12.FavoriteApi(gh<_i6.FavoriteRestClient>()));
    gh.factory<_i13.LocationApi>(
        () => _i13.LocationApi(gh<_i7.LocationRestClient>()));
    gh.factory<_i14.PawApi>(() => _i14.PawApi(gh<_i8.PawEntryRestClient>()));
    gh.factory<_i15.UtilsApi>(() => _i15.UtilsApi(gh<_i9.UtilsRestClient>()));
    gh.factory<_i16.AuthApi>(() => _i16.AuthApi(gh<_i10.AuthRestClient>()));
    gh.factory<_i17.CategoryApi>(
        () => _i17.CategoryApi(gh<_i11.CategoryRestClient>()));
    return this;
  }
}

class _$NetworkModule extends _i18.NetworkModule {}
