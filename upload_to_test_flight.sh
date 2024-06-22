# Script for uploading an ipa file to TestFlight
echo "🚀 Uploading to TestFlight"
if [ "$1" != "-f" ]; then
	flutter clean
	flutter pub get
	dart run build_runner build --delete-conflicting-outputs
fi
cd ios
bundle exec fastlane upload_to_ios_testflight
cd ..
echo "🚀 Upload to TestFlight complete"