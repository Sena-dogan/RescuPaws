import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../constants/endpoints.dart';
import '../../../models/location_response.dart';

part 'location_rest_client.g.dart';

@RestApi(baseUrl: Endpoints.baseUrl)
abstract class LocationRestClient {
  factory LocationRestClient(Dio dio, {String baseUrl}) = _LocationRestClient;

  @GET('/location/{countryId}/{cityId}')
  Future<GetLocationsResponse> getLocations(
    @Path('countryId') int countryId,
    @Path('cityId') int cityId,
  );

  @GET('/location')
  Future<GetLocationsResponse> getCountries();

  @GET('/location/{countryId}')
  Future<GetLocationsResponse> getCities(@Path('countryId') int countryId);
}
