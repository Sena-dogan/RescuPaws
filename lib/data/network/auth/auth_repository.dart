import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../di/components/service_locator.dart';
import '../../../models/token/token_request.dart';
import '../../../models/token/token_response.dart';
import '../auth_api.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._authApi);
  final AuthApi _authApi;

  Future<TokenResponse> getToken(TokenRequest tokenRequest) async {
    final TokenResponse tokenResponse = await _authApi.getToken(tokenRequest);
    return tokenResponse;
  }
}

@riverpod
AuthRepository getAuthRepository(Ref ref) {
  final AuthApi authApi = getIt<AuthApi>();
  return AuthRepository(authApi);
}
