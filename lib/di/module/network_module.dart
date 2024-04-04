// ignore_for_file: always_specify_types

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

import 'package:network_logger/network_logger.dart';

import '../../constants/endpoints.dart';
import '../../data/getstore/get_store_helper.dart';
import '../../data/network/auth/auth_rest_client.dart';
import '../../data/network/category/category_rest_client.dart';
import '../../data/network/favorite/favorite_rest_client.dart';
import '../../data/network/location/location_rest_client.dart';
import '../../data/network/paw_entry/paw_entry_rest_client.dart';
import '../../data/network/utils/utils_rest_client.dart';

/// NetworkModule is used to register network related dependencies.
/// @module is used to register the module.
/// @preResolve is used to make sure that the Future is resolved before the app starts.
/// @lazySingleton is used to make sure that the dependency is created only once.
/// @injectable is used to make sure that the dependency is created only once.
@module
abstract class NetworkModule {
  @preResolve
  Future<Dio> provideDio(GetStoreHelper getStoreHelper) {
    final Dio dio = Dio();
    final String? token = getStoreHelper.getToken();



    dio
      ..options.baseUrl = Endpoints.baseUrl
      ..options.connectTimeout =
          const Duration(milliseconds: Endpoints.connectionTimeout)
      ..options.receiveTimeout =
          const Duration(milliseconds: Endpoints.receiveTimeout)
      ..options.headers = {
        'Content-Type': 'application/json',
        'accept': 'text/plain',
        'Authorization': 'Bearer $token',
      }
      ..interceptors.add(LogInterceptor(
        responseBody: true,
        requestBody: true,
      ))
      ..interceptors.add(DioNetworkLogger())
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options,
              RequestInterceptorHandler handler) async {
            return handler.next(options);
          },
        ),
      );

    return Future.value(dio);
  }

  /// Register RestClients here to be used in the app.
  /// It is recommended to use @preResolve annotation to make sure that the
  /// Future is resolved before the app starts.

  @preResolve
  Future<GetStorage> provideGetStorage() {
    return Future.value(GetStorage());
  }

  @preResolve
  Future<PawEntryRestClient> providePawEntryRestClient(Dio dio) {
    return Future.value(PawEntryRestClient(dio));
  }

  @preResolve
  Future<CategoryRestClient> provideCategoryRestClient(Dio dio) {
    return Future.value(CategoryRestClient(dio));
  }

  @preResolve
  Future<UtilsRestClient> provideUtilsRestClient(Dio dio) {
    return Future.value(UtilsRestClient(dio));
  }

  @preResolve
  Future<LocationRestClient> provideLocationRestClient(Dio dio) {
    return Future.value(LocationRestClient(dio));
  }

  @preResolve
  Future<AuthRestClient> provideAuthRestClient(Dio dio) {
    return Future.value(AuthRestClient(dio));
  }

  @preResolve
  Future<FavoriteRestClient> provideFavoriteRestClient(Dio dio) {
    return Future.value(FavoriteRestClient(dio));
  }
}
