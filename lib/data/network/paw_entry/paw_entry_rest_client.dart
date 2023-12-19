import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../constants/endpoints.dart';
import '../../../models/paw_entry.dart';

part 'paw_entry_rest_client.g.dart';

@RestApi(baseUrl: Endpoints.baseUrl)
abstract class PawEntryRestClient {
  factory PawEntryRestClient(Dio dio, {String baseUrl}) = _PawEntryRestClient;

  @GET('/classfields')
  Future<GetPawEntryResponse> getPawEntry();

  @GET('/classfields/{id}')
  Future<GetPawEntryResponse> getPawEntryById(@Path('id') String id);
}
