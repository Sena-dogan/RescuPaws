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
  
}
