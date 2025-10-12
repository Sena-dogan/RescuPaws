/// Supabase configuration for RescuPaws
/// 
/// This file contains Supabase URL and API keys.
/// Get these from: https://app.supabase.com/project/_/settings/api
class SupabaseConfig {
  // Example: 'https://your-project-id.supabase.co'
  static const String supabaseUrl = 'https://aelzcgzhcuvqgrnfpgvd.supabase.co';
  
  // This is safe to use in client applications
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFlbHpjZ3poY3V2cWdybmZwZ3ZkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAyMTM5OTgsImV4cCI6MjA3NTc4OTk5OH0.8OFCFFlGtCJY2-UdoSZL68O6_6U9jcFHeNfXpfuPoOs';
  
  // Storage bucket name for paw entry images
  static const String imagesBucketName = 'paw-images';
  
  // Storage path pattern: {userId}/{timestamp}_{index}.jpg
  static String getImagePath(String userId, String fileName) {
    return '$userId/$fileName';
  }
  
  // Public URL for accessing images
  static String getPublicImageUrl(String path) {
    return '$supabaseUrl/storage/v1/object/public/$imagesBucketName/$path';
  }
}
