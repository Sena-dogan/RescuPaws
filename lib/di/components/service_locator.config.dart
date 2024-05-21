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

import '../../config/router/app_router.dart' as _i5;
import '../../data/getstore/get_store_helper.dart' as _i4;
import '../../data/network/auth/auth_rest_client.dart' as _i11;
import '../../data/network/auth_api.dart' as _i17;
import '../../data/network/category/category_rest_client.dart' as _i12;
import '../../data/network/category_api.dart' as _i18;
import '../../data/network/favorite/favorite_rest_client.dart' as _i7;
import '../../data/network/favorite_api.dart' as _i13;
import '../../data/network/location/location_rest_client.dart' as _i8;
import '../../data/network/location_api.dart' as _i14;
import '../../data/network/paw_api.dart' as _i15;
import '../../data/network/paw_entry/paw_entry_rest_client.dart' as _i9;
import '../../data/network/utils/utils_rest_client.dart' as _i10;
import '../../data/network/utils_api.dart' as _i16;
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
    gh.factory<_i4.GetStoreHelper>(
        () => _i4.GetStoreHelper(gh<_i3.GetStorage>()));
    gh.singleton<_i5.SGGoRouter>(_i5.SGGoRouter());
    await gh.factoryAsync<_i6.Dio>(
      () => networkModule.provideDio(gh<_i4.GetStoreHelper>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i7.FavoriteRestClient>(
      () => networkModule.provideFavoriteRestClient(gh<_i6.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i8.LocationRestClient>(
      () => networkModule.provideLocationRestClient(gh<_i6.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i9.PawEntryRestClient>(
      () => networkModule.providePawEntryRestClient(gh<_i6.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i10.UtilsRestClient>(
      () => networkModule.provideUtilsRestClient(gh<_i6.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i11.AuthRestClient>(
      () => networkModule.provideAuthRestClient(gh<_i6.Dio>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i12.CategoryRestClient>(
      () => networkModule.provideCategoryRestClient(gh<_i6.Dio>()),
      preResolve: true,
    );
    gh.factory<_i13.FavoriteApi>(
        () => _i13.FavoriteApi(gh<_i7.FavoriteRestClient>()));
    gh.factory<_i14.LocationApi>(
        () => _i14.LocationApi(gh<_i8.LocationRestClient>()));
    gh.factory<_i15.PawApi>(() => _i15.PawApi(gh<_i9.PawEntryRestClient>()));
    gh.factory<_i16.UtilsApi>(() => _i16.UtilsApi(gh<_i10.UtilsRestClient>()));
    gh.factory<_i17.AuthApi>(() => _i17.AuthApi(gh<_i11.AuthRestClient>()));
    gh.factory<_i18.CategoryApi>(
        () => _i18.CategoryApi(gh<_i12.CategoryRestClient>()));
    return this;
  }
}

class _$NetworkModule extends _i19.NetworkModule {}
