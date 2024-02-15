import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../constants/endpoints.dart';
import '../../../models/token/token_request.dart';
import '../../../models/token/token_response.dart';


part 'auth_rest_client.g.dart';

@RestApi(baseUrl: Endpoints.baseUrl)
abstract class AuthRestClient {
  factory AuthRestClient(Dio dio, {String baseUrl}) = _AuthRestClient;

  @POST('/auth/login')
  Future<TokenResponse> getToken(@Body() TokenRequest tokenRequest);
}
