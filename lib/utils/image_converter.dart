import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/images_upload.dart';
import '../models/paw_entry.dart';

class ImageConverter {
  ImageConverter._();
  static const Uuid _uuid = Uuid();

  static String base64ToDataUri(String base64String) {
    if (!_isValidBase64(base64String)) {
      return '';
    }
    return 'data:image/jpeg;base64,$base64String';
  }

  /// Converts base64 images to permanent files and returns updated PawEntry
  static Future<PawEntry> convertBase64ImagesToFiles(PawEntry pawEntry) async {
    if (pawEntry.image == null || pawEntry.image!.isEmpty) {
      return pawEntry;
    }

    final List<ImagesUploads> imageUploads = <ImagesUploads>[];
    
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory imagesDir = Directory('${appDir.path}/images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      
      for (int i = 0; i < pawEntry.image!.length; i++) {
        final String base64Image = pawEntry.image![i];
        
        // Skip if not a valid base64 string
        if (!_isValidBase64(base64Image)) {
          continue;
        }

        // Decode base64 to bytes
        final Uint8List imageBytes = base64Decode(base64Image);
        
        // Create permanent file
        final String fileName = '${_uuid.v4()}.jpg';
        final File imageFile = File('${imagesDir.path}/$fileName');
        
        // Write bytes to file
        await imageFile.writeAsBytes(imageBytes);
        
        // Create ImagesUploads object with file path
        final ImagesUploads imageUpload = ImagesUploads(
          id: i,
          user_id: pawEntry.user_id,
          class_field_id: pawEntry.id,
          path: imageFile.path,
          image_url: imageFile.path, // Use file path as URL for local files
          created_at: pawEntry.created_at,
          updated_at: pawEntry.updated_at,
        );
        
        imageUploads.add(imageUpload);
      }
    } catch (e) {
      debugPrint('Error converting base64 images: $e');
      // If conversion fails, return original entry
      return pawEntry;
    }

    // Return updated PawEntry with converted images
    return pawEntry.copyWith(images_uploads: imageUploads);
  }

  /// Converts base64 images to data URIs for direct use in widgets
  static PawEntry convertBase64ImagesToDataUri(PawEntry pawEntry) {
    if (pawEntry.image == null || pawEntry.image!.isEmpty) {
      return pawEntry;
    }

    final List<ImagesUploads> imageUploads = <ImagesUploads>[];
    
    for (int i = 0; i < pawEntry.image!.length; i++) {
      final String base64Image = pawEntry.image![i];
      
      // Skip if not a valid base64 string
      if (!_isValidBase64(base64Image)) {
        continue;
      }

      // Create data URI
      final String dataUri = 'data:image/jpeg;base64,$base64Image';
      
      // Create ImagesUploads object with data URI
      final ImagesUploads imageUpload = ImagesUploads(
        id: i,
        user_id: pawEntry.user_id,
        class_field_id: pawEntry.id,
        path: dataUri,
        image_url: dataUri,
        created_at: pawEntry.created_at,
        updated_at: pawEntry.updated_at,
      );
      
      imageUploads.add(imageUpload);
    }

    // Return updated PawEntry with converted images
    return pawEntry.copyWith(images_uploads: imageUploads);
  }

  /// Validates if a string is valid base64
  static bool _isValidBase64(String base64String) {
    if (base64String.isEmpty) return false;
    
    try {
      // Remove data URI prefix if present
      String cleanBase64 = base64String;
      if (base64String.startsWith('data:')) {
        final int commaIndex = base64String.indexOf(',');
        if (commaIndex != -1) {
          cleanBase64 = base64String.substring(commaIndex + 1);
        }
      }
      
      // Try to decode - if it fails, it's not valid base64
      base64Decode(cleanBase64);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Batch convert multiple PawEntries
  static Future<List<PawEntry>> convertMultipleEntries(
    List<PawEntry> entries, {
    bool useDataUri = true,
  }) async {
    final List<PawEntry> convertedEntries = <PawEntry>[];
    
    for (final PawEntry entry in entries) {
      if (useDataUri) {
        convertedEntries.add(convertBase64ImagesToDataUri(entry));
      } else {
        convertedEntries.add(await convertBase64ImagesToFiles(entry));
      }
    }
    
    return convertedEntries;
  }
}
