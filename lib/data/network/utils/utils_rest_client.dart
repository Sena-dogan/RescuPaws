import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../constants/endpoints.dart';
import '../../../models/convert_images.dart';

part 'utils_rest_client.g.dart';

@RestApi(baseUrl: Endpoints.baseUrl)
abstract class UtilsRestClient {
  factory UtilsRestClient(Dio dio, {String baseUrl}) = _UtilsRestClient;

  @POST('/convert-image')
  Future<ConvertImagesResponse> convertImages(
      @Body() ConvertImagesRequest body);
}
