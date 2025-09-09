# Location System Migration to Firestore

## Overview
The location system has been migrated from REST API to Firestore to provide better performance and consistency with the existing breed system.

## New Architecture

### Collections Structure

#### 1. Countries Collection: `countries`
- **Document ID**: Slugified name (e.g., `turkiye`)
- **Fields**:
  - `id`: Integer ID
  - `name`: Display name (e.g., "Türkiye")
  - `code`: Country code (e.g., "TR")
  - `createdAt`: ISO 8601 timestamp
  - `updatedAt`: ISO 8601 timestamp

#### 2. Cities Collection: `cities`
- **Document ID**: Slugified city name (e.g., `istanbul`, `ankara`, `izmir`)
- **Fields**:
  - `id`: Integer ID
  - `name`: City name (e.g., "İstanbul")
  - `countryId`: Reference to country (always 1 for Turkey)
  - `plateCode`: License plate code (e.g., "34")
  - `plateNumber`: Plate number as integer
  - `areaCode`: Phone area code
  - `population`: Population as string
  - `region`: Geographic region
  - `area`: Area in km²
  - `description`: Brief description
  - `createdAt`: ISO 8601 timestamp
  - `updatedAt`: ISO 8601 timestamp

#### 3. Districts Collection: `districts`
- **Document ID**: Combined format `{city_slug}_{district_slug}` or `{city_slug}_merkez`
- **Fields**:
  - `id`: Integer ID
  - `name`: District name (e.g., "Beşiktaş", "Ankara Merkez")
  - `cityId`: Reference to parent city
  - `plateNumber`: City plate number for easier queries
  - `createdAt`: ISO 8601 timestamp
  - `updatedAt`: ISO 8601 timestamp

## Key Features

### 1. Turkish Character Support
The slug generation handles Turkish characters properly:
- ş → s, ğ → g, ç → c, ı → i, ö → o, ü → u

### 2. Automatic Data Import
- Runs on app startup via `main.dart`
- Checks if data exists before importing (prevents duplicates)
- Uses batch operations for efficient writes

### 3. Performance Optimizations
- Removed composite indexes requirement by sorting in memory
- Uses collection-level queries without complex filtering
- Cached providers with `keepAlive: true`

## Services

### LocationImportService
- `importLocationsFromAssets()`: Import if not exists
- `forceImportLocations()`: Clear and re-import all data
- `clearAllLocations()`: Remove all location data

### LocationRepository
- `getCountries()`: Get all countries
- `getCities(countryId)`: Get cities for a country
- `getDistricts(cityId)`: Get districts for a city
- `getLocations(countryId, cityId)`: Get districts (legacy compatibility)

## Providers

### Location Providers
```dart
@Riverpod(keepAlive: true)
Future<GetLocationsResponse> fetchCountries(Ref ref)

@Riverpod(keepAlive: true) 
Future<GetLocationsResponse> fetchCities(Ref ref, int countryId)

@Riverpod(keepAlive: true)
Future<GetLocationsResponse> fetchLocations(Ref ref, {int countryId = 1, int cityId = 34})
```

## Usage Examples

### Get All Turkish Cities
```dart
final cities = await ref.watch(fetchCitiesProvider(1));
```

### Get Districts for a City
```dart
final districts = await locationRepository.getDistricts(cityId: selectedCity.id);
```

### Import Locations
```dart
await LocationImportService.importLocationsFromAssets();
```

## Migration Notes

### Screen Updates
- `address_input_screen.dart`: Updated to use `fetchCitiesProvider(1)` instead of `fetchLocationsProvider()`
- Location selection now properly loads Turkish provinces and districts

### Data Source
- Uses `assets/il-ilce.json` containing Turkish provinces and districts
- Asset registered in `pubspec.yaml`

### Firestore Requirements
- No composite indexes needed (queries are simple)
- Uses batch writes for efficiency
- All queries sorted in memory to avoid index requirements

## Testing
Use the `LocationTestPage` to manually test import functionality:
- Import locations
- Force re-import
- Clear all location data

## Future Enhancements
- Add support for other countries
- Implement district-level data from JSON if available
- Add location search functionality
- Cache frequently accessed locations locally
