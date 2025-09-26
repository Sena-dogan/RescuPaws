import 'dart:convert';

class ImageConverter {
  ImageConverter._();

  static String base64ToDataUri(String base64String) {
    if (!_isValidBase64(base64String)) {
      return '';
    }
    return 'data:image/jpeg;base64,$base64String';
  }

  /// Validates if a string is valid base64
  static bool _isValidBase64(String base64String) {
    if (base64String.isEmpty) return false;
    
    try {
      // Remove data URI prefix if present
      String cleanBase64 = base64String;
      if (base64String.startsWith('data:')) {
        int commaIndex = base64String.indexOf(',');
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
