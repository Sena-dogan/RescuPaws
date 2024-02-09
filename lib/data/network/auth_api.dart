/// All Restclients that communicate with the Paw requests are defined here.
import 'package:injectable/injectable.dart';

import '../../models/token/token_request.dart';
import '../../models/token/token_response.dart';
import 'auth/auth_rest_client.dart';

@injectable
class AuthApi {
  AuthApi(this._authRestClient);
  final AuthRestClient _authRestClient;

  Future<TokenResponse> getToken(TokenRequest tokenRequest) async {
    final TokenResponse tokenResponse =
        await _authRestClient.getToken(tokenRequest);
    return tokenResponse;
  }
}
