import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
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
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            if (errorWidget != null) {
              return errorWidget!(context, imageUrl, error);
            }
            return Image.network(
              'https://i.pinimg.com/736x/fc/05/5f/fc055f6e40faed757050d459b66e88b0.jpg',
              fit: fit,
            );
          },
        );
      } catch (e) {
        // If parsing fails, show error widget
        if (errorWidget != null) {
          return errorWidget!(context, imageUrl, e);
        }
        return Image.network(
          'https://i.pinimg.com/736x/fc/05/5f/fc055f6e40faed757050d459b66e88b0.jpg',
          fit: fit,
        );
      }
    }
    
    // Check if it's a local file path
    if (imageUrl.startsWith('/')) {
      return Image.asset(
        imageUrl,
        fit: fit,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          if (errorWidget != null) {
            return errorWidget!(context, imageUrl, error);
          }
          return Image.network(
            'https://i.pinimg.com/736x/fc/05/5f/fc055f6e40faed757050d459b66e88b0.jpg',
            fit: fit,
          );
        },
      );
    }

    // Default to CachedNetworkImage for URLs
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      errorWidget: errorWidget ?? (BuildContext context, String url, Object error) {
        return Image.network(
          'https://i.pinimg.com/736x/fc/05/5f/fc055f6e40faed757050d459b66e88b0.jpg',
          fit: fit,
        );
      },
    );
  }
}
