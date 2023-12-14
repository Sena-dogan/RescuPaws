import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../di/components/service_locator.dart';
import '../../../models/convert_images.dart';
import '../utils_api.dart';

part 'utils_repository.g.dart';

class UtilsRepository {
  UtilsRepository(this._utilsApi);
  final UtilsApi _utilsApi;

  Future<Either<Object, ConvertImagesResponse>> convertImages(
      ConvertImagesRequest body) async {
    return _utilsApi.convertImages(body);
  }
}

@riverpod
UtilsRepository getUtilsRepository(GetUtilsRepositoryRef ref) {
  final UtilsApi utilsApi = getIt<UtilsApi>();
  return UtilsRepository(utilsApi);
}
