// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:get_storage/get_storage.dart' as _i792;
import 'package:injectable/injectable.dart' as _i526;

import '../../config/router/app_router.dart' as _i238;
import '../../data/getstore/get_store_helper.dart' as _i478;
import '../../data/network/auth/auth_rest_client.dart' as _i553;
import '../../data/network/auth_api.dart' as _i1054;
import '../../data/network/category/category_rest_client.dart' as _i425;
import '../../data/network/category_api.dart' as _i601;
import '../../data/network/favorite/favorite_rest_client.dart' as _i962;
import '../../data/network/favorite_api.dart' as _i602;
import '../../data/network/location/location_rest_client.dart' as _i42;
import '../../data/network/location_api.dart' as _i392;
import '../../data/network/paw_api.dart' as _i867;
import '../../data/network/paw_entry/paw_entry_rest_client.dart' as _i996;
import '../../data/network/utils/utils_rest_client.dart' as _i667;
import '../../data/network/utils_api.dart' as _i710;
import '../module/network_module.dart' as _i1000;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    await gh.factoryAsync<_i792.GetStorage>(
      () => networkModule.provideGetStorage(),
      preResolve: true,
    );
    gh.singleton<_i238.SGGoRouter>(() => _i238.SGGoRouter());
    gh.factory<_i478.GetStoreHelper>(
        () => _i478.GetStoreHelper(gh<_i792.GetStorage>()));
    await gh.factoryAsync<_i361.Dio>(
      () => networkModule.provideDio(gh<_i478.GetStoreHelper>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i996.PawEntryRestClient>(
      () => networkModule.providePawEntryRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i425.CategoryRestClient>(
      () => networkModule.provideCategoryRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i667.UtilsRestClient>(
      () => networkModule.provideUtilsRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i42.LocationRestClient>(
      () => networkModule.provideLocationRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i553.AuthRestClient>(
      () => networkModule.provideAuthRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i962.FavoriteRestClient>(
      () => networkModule.provideFavoriteRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    gh.factory<_i601.CategoryApi>(
        () => _i601.CategoryApi(gh<_i425.CategoryRestClient>()));
    gh.factory<_i710.UtilsApi>(
        () => _i710.UtilsApi(gh<_i667.UtilsRestClient>()));
    gh.factory<_i867.PawApi>(
        () => _i867.PawApi(gh<_i996.PawEntryRestClient>()));
    gh.factory<_i1054.AuthApi>(
        () => _i1054.AuthApi(gh<_i553.AuthRestClient>()));
    gh.factory<_i602.FavoriteApi>(
        () => _i602.FavoriteApi(gh<_i962.FavoriteRestClient>()));
    gh.factory<_i392.LocationApi>(
        () => _i392.LocationApi(gh<_i42.LocationRestClient>()));
    return this;
  }
}

class _$NetworkModule extends _i1000.NetworkModule {}
