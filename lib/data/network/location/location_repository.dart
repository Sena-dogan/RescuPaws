import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../di/components/service_locator.dart';
import '../../../models/location_response.dart';
import '../location_api.dart';

part 'location_repository.g.dart';

class LocationRepository {
  LocationRepository(this._locationApi);
  final LocationApi _locationApi;

  Future<GetLocationsResponse> getLocations(
      {int countryId = 1, int cityId = 1}) async {
    // Best part of functional programming: no try-catch blocks!
    // Instead, we use Either to return either a String or a PawEntry.
    // If the request fails, we return a String with the error message.
    // If the request succeeds, we return a PawEntry.
    final GetLocationsResponse locations =
        await _locationApi.getLocations(countryId, cityId);
    Logger().i('locations: ${locations.districts}');
    return locations;
  }

  Future<GetLocationsResponse> getCountries() async {
    final GetLocationsResponse countries = await _locationApi.getCountries();
    return countries;
  }

  Future<GetLocationsResponse> getCities(int countryId) async {
    final GetLocationsResponse cities = await _locationApi.getCities(countryId);
    return cities;
  }

  Future<GetLocationsResponse> getDistricts({int countryId = 1, required int cityId}) async {
    final GetLocationsResponse districts =
        await _locationApi.getDistricts(countryId, cityId);
    return districts;
  }
}

@riverpod
LocationRepository getLocationRepository(Ref ref) {
  final LocationApi locationApi = getIt<LocationApi>();
  return LocationRepository(locationApi);
}

@riverpod
Future<GetLocationsResponse> fetchLocations(Ref ref,
    {int countryId = 1, int cityId = 34}) async {
  final LocationRepository locationRepository =
      ref.read(getLocationRepositoryProvider);
  final GetLocationsResponse locations = await locationRepository.getLocations(
      countryId: countryId, cityId: cityId);
  return locations;
}

@riverpod
Future<GetLocationsResponse> fetchCountries(Ref ref) async {
  final LocationRepository locationRepository =
      ref.read(getLocationRepositoryProvider);
  final GetLocationsResponse countries =
      await locationRepository.getCountries();
  return countries;
}

@riverpod
Future<GetLocationsResponse> fetchCities(
    Ref ref, int countryId) async {
  final LocationRepository locationRepository =
      ref.read(getLocationRepositoryProvider);
  final GetLocationsResponse cities =
      await locationRepository.getCities(countryId);
  return cities;
}
