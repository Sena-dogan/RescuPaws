// dart format width=80
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
import 'package:pati_pati/data/getstore/get_store_helper.dart' as _i467;
import 'package:pati_pati/data/network/auth/auth_rest_client.dart' as _i371;
import 'package:pati_pati/data/network/auth_api.dart' as _i404;
import 'package:pati_pati/data/network/category/category_rest_client.dart'
    as _i378;
import 'package:pati_pati/data/network/category_api.dart' as _i707;
import 'package:pati_pati/data/network/favorite/favorite_rest_client.dart'
    as _i698;
import 'package:pati_pati/data/network/favorite_api.dart' as _i952;
import 'package:pati_pati/data/network/location/location_rest_client.dart'
    as _i585;
import 'package:pati_pati/data/network/location_api.dart' as _i663;
import 'package:pati_pati/data/network/paw_api.dart' as _i207;
import 'package:pati_pati/data/network/paw_entry/paw_entry_rest_client.dart'
    as _i784;
import 'package:pati_pati/data/network/utils/utils_rest_client.dart' as _i139;
import 'package:pati_pati/data/network/utils_api.dart' as _i374;
import 'package:pati_pati/di/module/network_module.dart' as _i69;

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
    gh.factory<_i467.GetStoreHelper>(
        () => _i467.GetStoreHelper(gh<_i792.GetStorage>()));
    await gh.factoryAsync<_i361.Dio>(
      () => networkModule.provideDio(gh<_i467.GetStoreHelper>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i784.PawEntryRestClient>(
      () => networkModule.providePawEntryRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i378.CategoryRestClient>(
      () => networkModule.provideCategoryRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i139.UtilsRestClient>(
      () => networkModule.provideUtilsRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i585.LocationRestClient>(
      () => networkModule.provideLocationRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i371.AuthRestClient>(
      () => networkModule.provideAuthRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i698.FavoriteRestClient>(
      () => networkModule.provideFavoriteRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    gh.factory<_i707.CategoryApi>(
        () => _i707.CategoryApi(gh<_i378.CategoryRestClient>()));
    gh.factory<_i374.UtilsApi>(
        () => _i374.UtilsApi(gh<_i139.UtilsRestClient>()));
    gh.factory<_i207.PawApi>(
        () => _i207.PawApi(gh<_i784.PawEntryRestClient>()));
    gh.factory<_i404.AuthApi>(() => _i404.AuthApi(gh<_i371.AuthRestClient>()));
    gh.factory<_i952.FavoriteApi>(
        () => _i952.FavoriteApi(gh<_i698.FavoriteRestClient>()));
    gh.factory<_i663.LocationApi>(
        () => _i663.LocationApi(gh<_i585.LocationRestClient>()));
    return this;
  }
}

class _$NetworkModule extends _i69.NetworkModule {}
