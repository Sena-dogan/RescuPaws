import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class AdaptiveImage extends StatelessWidget {
  const AdaptiveImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.errorWidget,
  });

  final String imageUrl;
  final BoxFit fit;
  final Widget Function(BuildContext, String, Object)? errorWidget;

  @override
  Widget build(BuildContext context) {
    // Check if it's a data URI
    if (imageUrl.startsWith('data:image')) {
      try {
        // Extract base64 data from data URI
        final String base64Data = imageUrl.split(',')[1];
        final Uint8List bytes = base64Decode(base64Data);

        return Image.memory(
          bytes,
          fit: fit,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
                debugPrint(
                  'Error occured while loading image from data URI: $error',
                );
                if (errorWidget != null) {
                  return errorWidget!(context, imageUrl, error);
                }

                return const Icon(Icons.broken_image);
              },
        );
      } catch (e) {
        debugPrint('Failed to parse data URI: $e');
        // If parsing fails, show error widget
        if (errorWidget != null) {
          return errorWidget!(context, imageUrl, e);
        }
        return const Icon(Icons.broken_image);
      }
    }

    // Check if it's a base64 string (not a data URI)
    if (_isValidBase64(imageUrl)) {
      try {
        final Uint8List bytes = base64Decode(imageUrl);
        return Image.memory(
          bytes,
          fit: fit,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
                debugPrint(
                  'Error occured while loading image from base64: $error',
                );
                if (errorWidget != null) {
                  return errorWidget!(context, imageUrl, error);
                }
                return const Icon(Icons.broken_image);
              },
        );
      } catch (e) {
        debugPrint('Failed to decode base64: $e');
        if (errorWidget != null) {
          return errorWidget!(context, imageUrl, e);
        }
        return const Icon(Icons.broken_image);
      }
    }

    // Check if it's a file path (absolute path to local file)
    if (imageUrl.startsWith('/') || imageUrl.contains('/')) {
      final File imageFile = File(imageUrl);
      if (imageFile.existsSync()) {
        return Image.file(
          imageFile,
          fit: fit,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
                debugPrint(
                  'Error occured while loading image from file: $error',
                );
                if (errorWidget != null) {
                  return errorWidget!(context, imageUrl, error);
                }
                return const Icon(Icons.broken_image);
              },
        );
      } else {
        debugPrint('Image file does not exist: $imageUrl');
        if (errorWidget != null) {
          return errorWidget!(context, imageUrl, 'File not found');
        }
        return const Icon(Icons.broken_image);
      }
    }

    // Default to CachedNetworkImage for URLs
    return const Icon(Icons.image);
  }

  /// Validates if a string is valid base64
  bool _isValidBase64(String base64String) {
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
}
