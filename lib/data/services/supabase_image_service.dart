import 'dart:io';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:rescupaws/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for uploading images to Supabase Storage
@lazySingleton
class SupabaseImageService {
  
  SupabaseImageService(this._logger) {
    _initializeSupabase();
  }
  final Logger _logger;
  late final SupabaseClient _supabase;
  
  void _initializeSupabase() {
    try {
      _supabase = Supabase.instance.client;
      _logger.i('Supabase client initialized');
    } catch (e) {
      _logger.e('Error initializing Supabase client: $e');
      rethrow;
    }
  }
  
  /// Upload a single image to Supabase Storage
  /// 
  /// [imageBytes] - The image data as bytes
  /// [userId] - The user ID for organizing images
  /// [fileName] - The file name (e.g., 'paw_123456789_0.jpg')
  /// 
  /// Returns the public URL of the uploaded image
  Future<String> uploadImage({
    required Uint8List imageBytes,
    required String userId,
    required String fileName,
  }) async {
    try {
      _logger.i('Uploading image: $fileName for user: $userId');
      
      String path = SupabaseConfig.getImagePath(userId, fileName);
      
      // Upload to Supabase Storage
      await _supabase.storage
          .from(SupabaseConfig.imagesBucketName)
          .uploadBinary(
            path,
            imageBytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true, // Allow overwriting if file exists
            ),
          );
      
      // Get public URL
      String publicUrl = _supabase.storage
          .from(SupabaseConfig.imagesBucketName)
          .getPublicUrl(path);
      
      _logger.i('Image uploaded successfully: $publicUrl');
      return publicUrl;
    } catch (e) {
      _logger.e('Error uploading image to Supabase: $e');
      rethrow;
    }
  }
  
  /// Upload multiple images to Supabase Storage
  /// 
  /// [imageBytesList] - List of image data as bytes
  /// [userId] - The user ID for organizing images
  /// [baseFileName] - Base name for files (timestamp will be added)
  /// 
  /// Returns a list of public URLs for the uploaded images
  Future<List<String>> uploadImages({
    required List<Uint8List> imageBytesList,
    required String userId,
    String? baseFileName,
  }) async {
    List<String> urls = <String>[];
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String base = baseFileName ?? 'paw_$timestamp';
    
    for (int i = 0; i < imageBytesList.length; i++) {
      String fileName = '${base}_$i.jpg';
      String url = await uploadImage(
        imageBytes: imageBytesList[i],
        userId: userId,
        fileName: fileName,
      );
      urls.add(url);
    }
    
    return urls;
  }
  
  /// Upload image from File
  Future<String> uploadImageFromFile({
    required File imageFile,
    required String userId,
    required String fileName,
  }) async {
    Uint8List imageBytes = await imageFile.readAsBytes();
    return uploadImage(
      imageBytes: imageBytes,
      userId: userId,
      fileName: fileName,
    );
  }
  
  /// Delete an image from Supabase Storage
  /// 
  /// [imageUrl] - The public URL of the image to delete
  Future<void> deleteImage(String imageUrl) async {
    try {
      // Extract path from URL
      Uri uri = Uri.parse(imageUrl);
      List<String> pathSegments = uri.pathSegments;
      
      // Path format: storage/v1/object/public/{bucket}/{path}
      int bucketIndex = pathSegments.indexOf(SupabaseConfig.imagesBucketName);
      if (bucketIndex == -1 || bucketIndex == pathSegments.length - 1) {
        throw Exception('Invalid image URL format');
      }
      
      String path = pathSegments.sublist(bucketIndex + 1).join('/');
      
      await _supabase.storage
          .from(SupabaseConfig.imagesBucketName)
          .remove(<String>[path]);
      
      _logger.i('Image deleted successfully: $path');
    } catch (e) {
      _logger.e('Error deleting image from Supabase: $e');
      rethrow;
    }
  }
  
  /// Delete multiple images from Supabase Storage
  Future<void> deleteImages(List<String> imageUrls) async {
    for (String url in imageUrls) {
      await deleteImage(url);
    }
  }
}
