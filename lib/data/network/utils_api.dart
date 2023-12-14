/// All Restclients that communicate with the Paw requests are defined here.
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../models/convert_images.dart';
import 'utils/utils_rest_client.dart';

@injectable
class UtilsApi {
  UtilsApi(this._utilsRestClient);
  final UtilsRestClient _utilsRestClient;

  Future<Either<Object, ConvertImagesResponse>> convertImages(ConvertImagesRequest body) async {
    try {
      final ConvertImagesResponse images =
          await _utilsRestClient.convertImages(body);
      return right(images);
    } catch (e) {
      return left(e);
    }
  }
}
