import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/router/app_router.dart';
import '../../../../constants/assets.dart';
import '../../../../utils/context_extensions.dart';
import '../logic/new_paw_logic.dart';
import '../model/new_paw_ui_model.dart';

class NewPawImageScreen extends ConsumerStatefulWidget {
  const NewPawImageScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewPawImageScreenState();
}

class _NewPawImageScreenState extends ConsumerState<NewPawImageScreen> {
  List<AssetEntity>? assets;

  @override
  Widget build(BuildContext context) {
    final NewPawUiModel newPaw = ref.watch(newPawLogicProvider);
    final AsyncValue<PermissionState> ps =
        ref.watch(fetchPermissionStateProvider);
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        image: const DecorationImage(
          image: AssetImage(Assets.LoginBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ps.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace? stackTrace) =>
              const Center(child: CircularProgressIndicator()),
          data: (PermissionState ps) {
            if (newPaw.isImageLoading == true ||
                (newPaw.assets != null && newPaw.assets!.isNotEmpty == true))
              return const Center(child: CircularProgressIndicator());
            //TODO: Fix InstaAssetPicker reappering after image selection
            if (mounted &&
                    newPaw.isImageLoading == false &&
                    ps == PermissionState.authorized ||
                ps == PermissionState.limited)
              InstaAssetPicker.pickAssets(context,
                  maxAssets: 5, closeOnComplete: true,
                  onCompleted: (Stream<InstaAssetsExportDetails> assetStream) {
                if (!mounted) return;
              }).then((List<AssetEntity>? selectedAssets) async {
                if (selectedAssets == null) return;
                final List<AssetEntity> assets = selectedAssets;
                await ref
                    .read(newPawLogicProvider.notifier)
                    .addAssets(assets)
                    .then((_) async {
                  debugPrint('assets added');
                  debugPrint('assets picked');
                  await context.push(SGRoute.newpaw.route);
                });
              });
            return _handleError(context);
          },
        ),
      ),
    );
  }

  Container _handleError(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        image: const DecorationImage(
          image: AssetImage(Assets.LoginBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Lottie.asset(
                Assets.Error,
                repeat: true,
                height: 200,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    'Patili dostunuzun fotoğrafları için izninize ihtiyacımız var.'),
              ),
              const Gap(16),
              ElevatedButton(
                onPressed: () async {
                  await PhotoManager.openSetting();
                  final PermissionState ps =
                      await PhotoManager.requestPermissionExtend();
                  if (ps == PermissionState.authorized) {
                    // ignore: unused_result
                    ref.refresh(fetchPermissionStateProvider);
                  }
                },
                child: Text('Izin Ver', style: context.textTheme.bodyMedium),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('dispose');
    super.dispose();
  }
}

// class ImagePreviewSlider extends ConsumerStatefulWidget {
//   const ImagePreviewSlider({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _ImagePreviewSliderState();
// }

// class _ImagePreviewSliderState extends ConsumerState<ImagePreviewSlider> {
//   late CarouselController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = CarouselController();
//     controller.onReady.then((_) {
//       ref.read(newPawLogicProvider.notifier).setController(controller);
//     });
//     InstaAssetPicker.pickAssets(context,
//         onCompleted: (Stream<InstaAssetsExportDetails> a) {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<AssetEntity> assets =
//         ref.watch(newPawLogicProvider).assets ?? <AssetEntity>[];
//     return Container(
//       color: Colors.black,
//       width: context.width,
//       child: Row(
//         children: <Widget>[
//           IconButton(
//             onPressed: () {
//               debugPrint('back');
//               controller.previousPage();
//             },
//             icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           ),
//           const Gap(16),
//           Expanded(
//             child: CarouselSlider(
//               carouselController: controller,
//               items: assets
//                   .map((AssetEntity e) => FutureBuilder<Uint8List?>(
//                         future: e.originBytes,
//                         builder: (_, AsyncSnapshot<Uint8List?> snapshot) {
//                           final Uint8List? bytes = snapshot.data;
//                           // If we have no data, display a spinner
//                           if (bytes == null)
//                             return const Center(
//                                 child: CircularProgressIndicator.adaptive());
//                           // If there's data, display it as an image
//                           return CachedMemoryImage(
//                             uniqueKey: e.id,
//                             bytes: bytes,
//                             fit: BoxFit.fitHeight,
//                           );
//                         },
//                       ))
//                   .toList(),
//               options: CarouselOptions(
//                   viewportFraction: 1,
//                   enableInfiniteScroll: false,
//                   aspectRatio: 1),
//             ),
//           ),
//           const Gap(16),
//           IconButton(
//             onPressed: () {
//               debugPrint('next');
//               controller.nextPage();
//             },
//             icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class GalleryListBuilder extends ConsumerWidget {
//   const GalleryListBuilder({
//     super.key,
//     required this.onTap,
//   });

//   final Function(AssetEntity)? onTap;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final AsyncValue<List<AssetEntity>> images = ref.watch(fetchImagesProvider);
//     return images.when(
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (Object error, StackTrace? stackTrace) =>
//           const Center(child: CircularProgressIndicator()),
//       data: (List<AssetEntity> images) {
//         final List<Widget> assetList = images
//             .map((AssetEntity e) => AssetThumbnail(
//                   asset: e,
//                   onTap: () {
//                     debugPrint('tapped');
//                     ref.read(newPawLogicProvider.notifier).addImage(e);
//                     onTap?.call(e);
//                   },
//                 ))
//             .toList();
//         final List<Widget> cameraAndGallery = <Widget>[];
//         cameraAndGallery.add(
//           CameraWidget(
//             onSaved: (AssetEntity? asset) {
//               if (asset != null) {
//                 cameraAndGallery.add(
//                   AssetThumbnail(
//                     asset: asset,
//                     onTap: () {
//                       debugPrint('tapped');
//                       ref.read(newPawLogicProvider.notifier).addImage(asset);
//                       onTap?.call(asset);
//                     },
//                   ),
//                 );
//               }
//             },
//           ),
//         );
//         cameraAndGallery.add(
//           const GalleryWidget(),
//         );
//         cameraAndGallery.addAll(assetList);
//         return SizedBox(
//           width: context.width,
//           height: context.height,
//           child: SafeArea(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 const Expanded(
//                   flex: 2,
//                   child: ImagePreviewSlider(),
//                 ),
//                 Expanded(
//                   flex: 4,
//                   child: GridView.builder(
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                     ),
//                     itemCount: cameraAndGallery.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return SizedBox(
//                         child: cameraAndGallery[index],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class AssetThumbnail extends ConsumerWidget {
//   const AssetThumbnail({
//     super.key,
//     required this.asset,
//     this.isSelected = false,
//     this.onTap,
//   });

//   final AssetEntity asset;
//   final bool isSelected;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final NewPawUiModel newPawUiModel = ref.watch(newPawLogicProvider);
//     // We're using a FutureBuilder since thumbData is a future
//     return FutureBuilder<Uint8List?>(
//       future: asset.thumbnailData,
//       builder: (_, AsyncSnapshot<Uint8List?> snapshot) {
//         final Uint8List? bytes = snapshot.data;
//         // If we have no data, display a spinner
//         if (bytes == null) return const CircularProgressIndicator();
//         // If there's data, display it as an image
//         return InkWell(
//           onTap: () {
//             onTap?.call();
//           },
//           child: SizedBox(
//             child: Stack(
//               children: <Widget>[
//                 CachedMemoryImage(
//                     uniqueKey: asset.id,
//                     bytes: bytes,
//                     fit: BoxFit.fitWidth,
//                     width: 300,
//                     height: 300),
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: Container(
//                     color: Colors.black.withOpacity(0.5),
//                     child: Visibility(
//                         visible: newPawUiModel.assets?.contains(asset) ?? false,
//                         child: const Icon(Icons.check, color: Colors.white)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class CameraWidget extends ConsumerWidget {
//   const CameraWidget({super.key, this.onSaved});
//   final Function(AssetEntity?)? onSaved;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return InkWell(
//       onTap: () async {
//         await ImagePicker()
//             .pickImage(source: ImageSource.camera)
//             .then((XFile? image) async {
//           await ref
//               .read(newPawLogicProvider.notifier)
//               .addFile(image == null ? null : File(image.path))
//               .then((AssetEntity? asset) => onSaved?.call(asset));
//         });
//       },
//       child: Container(
//         color: context.colorScheme.primary,
//         child: const Center(
//           child: Icon(Icons.camera_alt, color: Colors.black, size: 42),
//         ),
//       ),
//     );
//   }
// }

// class GalleryWidget extends StatelessWidget {
//   const GalleryWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {},
//       child: Container(
//         color: context.colorScheme.primary,
//         child: const Center(
//           child: Icon(Icons.photo_library, color: Colors.black, size: 42),
//         ),
//       ),
//     );
//   }
// }
