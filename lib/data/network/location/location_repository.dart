import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:rescupaws/models/location_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_repository.g.dart';

class LocationRepository {
  LocationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<GetLocationsResponse> getLocations(
      {int countryId = 1, int cityId = 1}) async {
    try {
      // Get districts for a specific city
      QuerySnapshot<Map<String, dynamic>> districtsSnapshot = await _firestore
          .collection('districts')
          .where('cityId', isEqualTo: cityId)
          .get();

      List<District> districts = districtsSnapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        Map<String, dynamic> data = doc.data();
        return District(
          id: data['id'] as int,
          name: data['name'] as String,
          cityId: data['cityId'] as int,
        );
      }).toList()

      // Sort by name in memory to avoid composite index requirement
      ..sort((District a, District b) => a.name.compareTo(b.name));

      Logger().i('districts: $districts');
      return GetLocationsResponse(districts: districts);
    } catch (e) {
      Logger().e('Error getting locations: $e');
      throw Exception('Failed to get locations: $e');
    }
  }

  Future<GetLocationsResponse> getCountries() async {
    try {
      QuerySnapshot<Map<String, dynamic>> countriesSnapshot = await _firestore
          .collection('countries')
          .orderBy('name')
          .get();

      List<Country> countries = countriesSnapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        Map<String, dynamic> data = doc.data();
        return Country(
          id: data['id'] as int,
          name: data['name'] as String,
          code: data['code'] as String,
        );
      }).toList();

      return GetLocationsResponse(countries: countries);
    } catch (e) {
      Logger().e('Error getting countries: $e');
      throw Exception('Failed to get countries: $e');
    }
  }

  Future<GetLocationsResponse> getCities(int countryId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> citiesSnapshot = await _firestore
          .collection('cities')
          .where('countryId', isEqualTo: countryId)
          .get();

      List<City> cities = citiesSnapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        Map<String, dynamic> data = doc.data();
        return City(
          id: data['id'] as int,
          name: data['name'] as String,
          countryId: data['countryId'] as int,
        );
      }).toList()

      // Sort by name in memory to avoid composite index requirement
      ..sort((City a, City b) => a.name.compareTo(b.name));

      return GetLocationsResponse(cities: cities);
    } catch (e) {
      Logger().e('Error getting cities: $e');
      throw Exception('Failed to get cities: $e');
    }
  }

  Future<GetLocationsResponse> getDistricts({int countryId = 1, required int cityId}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> districtsSnapshot = await _firestore
          .collection('districts')
          .where('cityId', isEqualTo: cityId)
          .get();

      List<District> districts = districtsSnapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        Map<String, dynamic> data = doc.data();
        return District(
          id: data['id'] as int,
          name: data['name'] as String,
          cityId: data['cityId'] as int,
        );
      }).toList()

      // Sort by name in memory to avoid composite index requirement
      ..sort((District a, District b) => a.name.compareTo(b.name));

      return GetLocationsResponse(districts: districts);
    } catch (e) {
      Logger().e('Error getting districts: $e');
      throw Exception('Failed to get districts: $e');
    }
  }
}

@Riverpod(keepAlive: true)
LocationRepository getLocationRepository(Ref ref) {
  return LocationRepository();
}

@Riverpod(keepAlive: true)
Future<GetLocationsResponse> fetchLocations(Ref ref,
    {int countryId = 1, int cityId = 34}) async {
  LocationRepository locationRepository =
      ref.read(getLocationRepositoryProvider);
  GetLocationsResponse locations = await locationRepository.getLocations(
      countryId: countryId, cityId: cityId);
  return locations;
}

@Riverpod(keepAlive: true)
Future<GetLocationsResponse> fetchCountries(Ref ref) async {
  LocationRepository locationRepository =
      ref.read(getLocationRepositoryProvider);
  GetLocationsResponse countries =
      await locationRepository.getCountries();
  return countries;
}

@Riverpod(keepAlive: true)
Future<GetLocationsResponse> fetchCities(
    Ref ref, int countryId) async {
  LocationRepository locationRepository =
      ref.read(getLocationRepositoryProvider);
  GetLocationsResponse cities =
      await locationRepository.getCities(countryId);
  return cities;
}
