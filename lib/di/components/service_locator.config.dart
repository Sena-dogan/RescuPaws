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
import 'package:rescupaws/data/getstore/get_store_helper.dart' as _i489;
import 'package:rescupaws/data/network/auth/auth_rest_client.dart' as _i140;
import 'package:rescupaws/data/network/auth_api.dart' as _i770;
import 'package:rescupaws/data/network/category/category_rest_client.dart'
    as _i742;
import 'package:rescupaws/data/network/category_api.dart' as _i432;
import 'package:rescupaws/data/network/favorite/favorite_rest_client.dart'
    as _i968;
import 'package:rescupaws/data/network/favorite_api.dart' as _i88;
import 'package:rescupaws/data/network/location/location_rest_client.dart'
    as _i11;
import 'package:rescupaws/data/network/location_api.dart' as _i990;
import 'package:rescupaws/data/network/paw_api.dart' as _i849;
import 'package:rescupaws/data/network/paw_entry/paw_entry_rest_client.dart'
    as _i1014;
import 'package:rescupaws/data/network/utils/utils_rest_client.dart' as _i364;
import 'package:rescupaws/data/network/utils_api.dart' as _i632;
import 'package:rescupaws/di/module/network_module.dart' as _i122;

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
    gh.factory<_i489.GetStoreHelper>(
        () => _i489.GetStoreHelper(gh<_i792.GetStorage>()));
    await gh.factoryAsync<_i361.Dio>(
      () => networkModule.provideDio(gh<_i489.GetStoreHelper>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i1014.PawEntryRestClient>(
      () => networkModule.providePawEntryRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i742.CategoryRestClient>(
      () => networkModule.provideCategoryRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i364.UtilsRestClient>(
      () => networkModule.provideUtilsRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i11.LocationRestClient>(
      () => networkModule.provideLocationRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i140.AuthRestClient>(
      () => networkModule.provideAuthRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i968.FavoriteRestClient>(
      () => networkModule.provideFavoriteRestClient(gh<_i361.Dio>()),
      preResolve: true,
    );
    gh.factory<_i849.PawApi>(
        () => _i849.PawApi(gh<_i1014.PawEntryRestClient>()));
    gh.factory<_i432.CategoryApi>(
        () => _i432.CategoryApi(gh<_i742.CategoryRestClient>()));
    gh.factory<_i770.AuthApi>(() => _i770.AuthApi(gh<_i140.AuthRestClient>()));
    gh.factory<_i88.FavoriteApi>(
        () => _i88.FavoriteApi(gh<_i968.FavoriteRestClient>()));
    gh.factory<_i990.LocationApi>(
        () => _i990.LocationApi(gh<_i11.LocationRestClient>()));
    gh.factory<_i632.UtilsApi>(
        () => _i632.UtilsApi(gh<_i364.UtilsRestClient>()));
    return this;
  }
}

class _$NetworkModule extends _i122.NetworkModule {}
