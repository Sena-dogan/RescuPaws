import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../constants/endpoints.dart';
import '../../../models/new_paw_model.dart';
import '../../../models/paw_entry.dart';
import '../../../models/paw_entry_detail.dart';

part 'paw_entry_rest_client.g.dart';

@RestApi(baseUrl: Endpoints.baseUrl)
abstract class PawEntryRestClient {
  factory PawEntryRestClient(Dio dio, {String baseUrl}) = _PawEntryRestClient;

  @GET('/classfields')
  Future<GetPawEntryResponse> getPawEntry();

  @GET('/show/user-classfields/{uid}')
  Future<GetPawEntryResponse> getUserPawEntries(@Path('uid') String uid);

  // Endpoint: "/classfields/{classfields_id}/show"
  @GET('/classfields/{classfields_id}/show')
  Future<GetPawEntryDetailResponse> getPawEntryDetail(
      @Path('classfields_id') String classfieldsId);

  @GET('/classfields/{id}')
  Future<GetPawEntryResponse> getPawEntryById(@Path('id') String id);

  @POST('/create-classfields')
  Future<NewPawResponse> createPawEntry(@Body() NewPawModel newPawModel);
}
