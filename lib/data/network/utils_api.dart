/// All Restclients that communicate with the Paw requests are defined here.
import 'package:injectable/injectable.dart';

import '../../models/convert_images.dart';
import '../../models/paw_entry.dart';
import 'paw_entry/paw_entry_rest_client.dart';
import 'utils/utils_rest_client.dart';

@injectable
class UtilsApi {
  UtilsApi(this._utilsRestClient);
  final UtilsRestClient _utilsRestClient;

  Future<ConvertImagesResponse> convertImages(ConvertImagesRequest body) async {
    final ConvertImagesResponse images =
        await _utilsRestClient.convertImages(body);
    return images;
  }
}
