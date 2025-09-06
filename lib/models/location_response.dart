// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_response.freezed.dart';
part 'location_response.g.dart';

@freezed
abstract class GetLocationsResponse with _$GetLocationsResponse {
  const factory GetLocationsResponse({
    @Default(<Country>[]) List<Country> countries,
    @Default(<City>[]) List<City> cities,
    @Default(<District>[]) List<District> districts,
  }) = _GetLocationsResponse;

  factory GetLocationsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetLocationsResponseFromJson(json);
}

@freezed
abstract class Country with _$Country {
  const factory Country({
    required int id,
    required String name,
    required String code,
  }) = _Country;

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);
}

@freezed
abstract class City with _$City {
  const factory City({
    required int id,
    required String name,
    required int countryId,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}

@freezed
abstract class District with _$District {
  const factory District({
    required int id,
    required String name,
    required int cityId,
  }) = _District;

  factory District.fromJson(Map<String, dynamic> json) =>
      _$DistrictFromJson(json);
}
