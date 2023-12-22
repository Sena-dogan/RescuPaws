import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../constants/endpoints.dart';
import '../../../models/location_response.dart';

part 'location_rest_client.g.dart';

@RestApi(baseUrl: Endpoints.baseUrl)
abstract class LocationRestClient {
  factory LocationRestClient(Dio dio, {String baseUrl}) = _LocationRestClient;

  @GET('/countries/{countryId}/{cityId}')
  Future<GetLocationsResponse> getLocations(
    @Path('countryId') int countryId,
    @Path('cityId') int cityId,
  );

  @GET('/countries')
  Future<GetLocationsResponse> getCountries();

  @GET('/cities/{countryId}')
  Future<GetLocationsResponse> getCities(@Path('countryId') int countryId);
}
