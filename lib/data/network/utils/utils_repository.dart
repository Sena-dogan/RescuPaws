import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../di/components/service_locator.dart';
import '../../../models/convert_images.dart';
import '../../../models/paw_entry.dart';
import '../paw_api.dart';
import '../utils_api.dart';

part 'utils_repository.g.dart';

class UtilsRepository {
  UtilsRepository(this._utilsApi);
  final UtilsApi _utilsApi;

  Future<ConvertImagesResponse> convertImages(ConvertImagesRequest body) async {
    final ConvertImagesResponse images =
        await _utilsApi.convertImages(body);
    return images;
  }
}


@riverpod
UtilsRepository getUtilsRepository(GetUtilsRepositoryRef ref) {
  final UtilsApi utilsApi = getIt<UtilsApi>();
  return UtilsRepository(utilsApi);
}
