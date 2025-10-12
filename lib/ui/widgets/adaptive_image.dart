import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AdaptiveImage extends StatelessWidget {
  const AdaptiveImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.placeholder,
  });

  final String imageUrl;
  final BoxFit fit;
  final Widget Function(BuildContext, String, Object)? errorWidget;
  final Widget Function(BuildContext, String)? placeholder;

  @override
  Widget build(BuildContext context) {
    // Check if it's a local file path
    if (imageUrl.startsWith('/') || (imageUrl.startsWith('file://') && !imageUrl.startsWith('file:///http'))) {
      String filePath = imageUrl.startsWith('file://') 
          ? imageUrl.substring('file://'.length) 
          : imageUrl;
      
      File imageFile = File(filePath);
      if (imageFile.existsSync()) {
        return Image.file(
          imageFile,
          fit: fit,
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            debugPrint('Error loading image from file: $error');
            if (errorWidget != null) {
              return errorWidget!(context, imageUrl, error);
            }
            return const Icon(Icons.broken_image, size: 50);
          },
        );
      } else {
        debugPrint('Image file does not exist: $imageUrl');
        if (errorWidget != null) {
          return errorWidget!(context, imageUrl, 'File not found');
        }
        return const Icon(Icons.broken_image, size: 50);
      }
    }

    // Check if it's a network URL (http/https or Supabase storage URL)
    if (imageUrl.startsWith('http://') || 
        imageUrl.startsWith('https://') ||
        imageUrl.contains('supabase.co/storage')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        placeholder: placeholder != null 
            ? (BuildContext context, String url) => placeholder!(context, url)
            : (BuildContext context, String url) => const Center(
                child: CircularProgressIndicator(),
              ),
        errorWidget: (BuildContext context, String url, Object error) {
          debugPrint('Error loading network image from $url: $error');
          if (errorWidget != null) {
            return errorWidget!(context, url, error);
          }
          return const Icon(Icons.broken_image, size: 50);
        },
      );
    }

    // Fallback for unrecognized format
    debugPrint('Unrecognized image format: $imageUrl');
    if (errorWidget != null) {
      return errorWidget!(context, imageUrl, 'Unsupported image format');
    }
    return const Icon(Icons.image_not_supported, size: 50);
  }
}
