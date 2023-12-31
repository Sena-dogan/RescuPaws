import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

Future<List<ImageFile>> pickImagesUsingImagePicker(bool allowMultiple) async {
  final ImagePicker picker = ImagePicker();
  final List<XFile> xFiles;
  if (allowMultiple) {
    xFiles = await picker.pickMultiImage(maxWidth: 1080, maxHeight: 1080);
  } else {
    xFiles = <XFile>[];
    final XFile? xFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
    if (xFile != null) {
      xFiles.add(xFile);
    }
  }
  if (xFiles.isNotEmpty) {
    return xFiles
        .map<ImageFile>((XFile e) => convertXFileToImageFile(e))
        .toList();
  }
  return <ImageFile>[];
}

Future<List<ImageFile>> pickImagesUsingFilePicker(bool allowMultiple) async {
  const List<String> allowedExtensions = <String>['png', 'jpeg', 'jpg'];
  final FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: allowMultiple,
    type: FileType.custom,
    withData: kIsWeb,
    allowedExtensions: allowedExtensions,
  );
  if (result != null && result.files.isNotEmpty) {
    return result.files
        .where((PlatformFile e) =>
            e.extension != null &&
            allowedExtensions.contains(e.extension?.toLowerCase()))
        .map(
          (PlatformFile e) => ImageFile(UniqueKey().toString(),
              name: e.name,
              extension: e.extension!,
              bytes: e.bytes,
              path: !kIsWeb ? e.path : null),
        )
        .toList();
  }
  return <ImageFile>[];
}

Future<List<ImageFile>> pickFilesUsingFilePicker(bool allowMultiple) async {
  final FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: allowMultiple,
    withData: kIsWeb,
  );
  if (result != null && result.files.isNotEmpty) {
    return result.files
        .map(
          (PlatformFile e) => convertPlatformFileToImageFile(e),
        )
        .toList();

    /*
    the below code can be used if not using convertPlatformFileToImageFile extension.
    return result.files
        .map(
          (e) => ImageFile(UniqueKey().toString(),
              name: e.name,
              extension: e.extension!,
              bytes: e.bytes,
              path: !kIsWeb ? e.path : null),
        )
        .toList();*/
  }
  return <ImageFile>[];
}
