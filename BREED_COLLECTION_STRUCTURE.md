# Breed Collection Structure

## New Firestore Collection Design

### Collection: `breeds`

#### Document Structure:
Each breed document uses the following format:

**Document ID:** `{species}_{slug}`
- Examples: `cat_abyssinian`, `dog_akita`, `cat_maine_coon`

#### Document Fields:

```json
{
  "species": "cat" | "dog",
  "name": "Abyssinian",
  "slug": "abyssinian",
  "attributes": {
    "Affectionate with Family": 3,
    "Amount of Shedding": 3,
    "Easy to Groom": 3,
    "General Health": 2,
    "Intelligence": 5,
    "Kid Friendly": 5,
    "Pet Friendly": 5,
    "Potential for Playfulness": 5
  },
  "createdAt": "2025-09-04T14:30:00Z",
  "updatedAt": "2025-09-04T14:30:00Z"
}
```

#### Future Fields (Optional):
- `name_tr`: Turkish translation of breed name
- `imageUrl`: URL to breed image
- `description`: Breed description
- `description_tr`: Turkish description

## Key Changes Made:

1. **Unified Collection**: Changed from separate `cat_breeds` and `dog_breeds` collections to a single `breeds` collection
2. **Document ID Format**: Now uses `{species}_{slug}` format (e.g., `cat_abyssinian`)
3. **Species Field**: Changed from `type` to `species` with values "cat" or "dog"
4. **Attributes**: Changed from `characteristics` to `attributes`
5. **Slug Field**: Added for cleaner URL-friendly identifiers

## Service Updates:

### BreedImportService:
- Updated to import to unified `breeds` collection
- Creates document IDs with species prefix
- Automatically generates slugs from breed names

### BreedService:
- Updated all methods to query the unified collection
- Uses `species` field for filtering cats vs dogs
- Updated method signatures to use `species` instead of `type`

### BreedModel:
- Updated field names: `type` → `species`, `characteristics` → `attributes`
- Added `slug` field
- Updated all getters and methods accordingly

## Usage Examples:

### Get Cat Breeds:
```dart
final catBreeds = await BreedService.getCatBreeds();
```

### Get Dog Breeds:
```dart
final dogBreeds = await BreedService.getDogBreeds();
```

### Search Breeds:
```dart
final results = await BreedService.searchBreeds('persian', 'cat');
```

### Get Specific Breed:
```dart
final breed = await BreedService.getBreed('cat', 'persian');
```

### Filter by Attributes:
```dart
final friendlyBreeds = await BreedService.getBreedsByAttribute(
  'dog', 
  'Kid Friendly', 
  4
);
```

## Import Process:

The breed data is automatically imported when the app starts:
1. Checks if breeds already exist in Firestore
2. If not, loads from `assets/cat-and-dog-breeds.json`
3. Processes and imports all breeds with proper document IDs and structure
4. Only imports once to avoid duplicates

## Development Tools:

For development and testing, these methods are available:
- `BreedImportService.forceImportBreeds()`: Force re-import all breeds
- `BreedImportService.clearAllBreeds()`: Clear all breeds from Firestore
