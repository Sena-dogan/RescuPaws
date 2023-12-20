
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../di/components/service_locator.dart';
import '../../../models/location_response.dart';
import '../location_api.dart';

part 'location_repository.g.dart';

class LocationRepository
{
  LocationRepository(this._locationApi);
  final LocationApi _locationApi;

  Future<GetLocationsResponse> getLocations({int countryId = 1, int cityId = 1}) async {
    // Best part of functional programming: no try-catch blocks!
    // Instead, we use Either to return either a String or a PawEntry.
    // If the request fails, we return a String with the error message.
    // If the request succeeds, we return a PawEntry.
    final GetLocationsResponse locations =
    await _locationApi.getLocations(countryId, cityId);
    return locations;
  }
}

@riverpod
LocationRepository getLocationRepository(GetLocationRepositoryRef ref) {
  final LocationApi locationApi = getIt<LocationApi>();
  return LocationRepository(locationApi);
}
