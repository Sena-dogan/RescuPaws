import 'package:injectable/injectable.dart';

import '../../models/location_response.dart';
import 'location/location_rest_client.dart';

@injectable
class LocationApi {
  LocationApi(this._locationyRestClient);
  final LocationRestClient _locationyRestClient;
  
  Future<GetLocationsResponse> getLocations(int countryId, int cityId) async {
    final GetLocationsResponse location =
        await _locationyRestClient.getLocations(countryId, cityId);
    return location;
  }

  Future<GetLocationsResponse> getCountries() async {
    final GetLocationsResponse countries =
        await _locationyRestClient.getCountries();
    return countries;
  }

  Future<GetLocationsResponse> getCities(int countryId) async {
    final GetLocationsResponse cities =
        await _locationyRestClient.getCities(countryId);
    return cities;
  }

  Future<GetLocationsResponse> getDistricts(int countryId, int cityId) async {
    final GetLocationsResponse districts =
        await _locationyRestClient.getLocations(countryId, cityId);
    return districts;
  }
  
}
