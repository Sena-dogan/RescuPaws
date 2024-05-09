// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:get_storage/get_storage.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;

import '../../config/router/app_router.dart' as _i4;
import '../../data/getstore/get_store_helper.dart' as _i5;
import '../../data/network/auth/auth_rest_client.dart' as _i11;
import '../../data/network/auth_api.dart' as _i16;
import '../../data/network/category/category_rest_client.dart' as _i8;
import '../../data/network/category_api.dart' as _i13;
import '../../data/network/favorite/favorite_rest_client.dart' as _i12;
import '../../data/network/favorite_api.dart' as _i17;
import '../../data/network/location/location_rest_client.dart' as _i10;
import '../../data/network/location_api.dart' as _i18;
import '../../data/network/paw_api.dart' as _i15;
import '../../data/network/paw_entry/paw_entry_rest_client.dart' as _i7;
import '../../data/network/utils/utils_rest_client.dart' as _i9;
import '../../data/network/utils_api.dart' as _i14;
import '../module/network_module.dart' as _i19;

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
    gh.singleton<_i4.SGGoRouter>(() => _i4.SGGoRouter());
    gh.factory<_i5.GetStoreHelper>(
        () => _i5.GetStoreHelper(gh<_i3.GetStorage>()));
    await gh.factoryAsync<_i6.Dio>(
      () => networkModule.provideDio(gh<_i5.GetStoreHelper>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i7.PawEntryRestClient>(
      () => networkModule.providePawEntryRestClient(gh<_i6.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i8.CategoryRestClient>(
      () => networkModule.provideCategoryRestClient(gh<_i6.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i9.UtilsRestClient>(
      () => networkModule.provideUtilsRestClient(gh<_i6.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i10.LocationRestClient>(
      () => networkModule.provideLocationRestClient(gh<_i6.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i11.AuthRestClient>(
      () => networkModule.provideAuthRestClient(gh<_i6.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i12.FavoriteRestClient>(
      () => networkModule.provideFavoriteRestClient(gh<_i6.Dio>()),
      preResolve: true,
    );
    gh.factory<_i13.CategoryApi>(
        () => _i13.CategoryApi(gh<_i8.CategoryRestClient>()));
    gh.factory<_i14.UtilsApi>(() => _i14.UtilsApi(gh<_i9.UtilsRestClient>()));
    gh.factory<_i15.PawApi>(() => _i15.PawApi(gh<_i7.PawEntryRestClient>()));
    gh.factory<_i16.AuthApi>(() => _i16.AuthApi(gh<_i11.AuthRestClient>()));
    gh.factory<_i17.FavoriteApi>(
        () => _i17.FavoriteApi(gh<_i12.FavoriteRestClient>()));
    gh.factory<_i18.LocationApi>(
        () => _i18.LocationApi(gh<_i10.LocationRestClient>()));
    return this;
  }
}

class _$NetworkModule extends _i19.NetworkModule {}
