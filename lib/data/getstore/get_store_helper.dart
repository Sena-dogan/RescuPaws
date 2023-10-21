import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

const String tokenKey = 'token';
const String introKey = 'intro';

@injectable

/// Example: GetStoreHelper is used to save and get token, email and password.
class GetStoreHelper {
  GetStoreHelper(this.getStorage);
  GetStorage getStorage;

  // save auth token
  Future<void> saveToken(String token) async {
    await getStorage.write(tokenKey, token);
  }

  Future<void> saveIntro(bool value) async {
    await getStorage.write(introKey, value);
  }

  bool? getIntro() {
    return getStorage.read(introKey);
  }

  // get auth token
  String? getToken() {
    return getStorage.read(tokenKey);
  }

  void clear() {
    getStorage.erase();
  }
}
