# Script for uploading an aab file to the Google Play Store
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
cd android
fastlane upload_APK_Playground
cd ..