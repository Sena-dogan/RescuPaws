import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:photo_manager/photo_manager.dart';

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
        color: context.colorScheme.background,
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
            if (ps != PermissionState.authorized) {
              return _handleError(context);
            } else {
              return GalleryListBuilder(
                onTap: (AssetEntity e) {},
              );
            }
          },
        ),
      ),
    );
  }

  Container _handleError(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.background,
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
              Image.asset(Assets.PawPaw),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                    'Patili dostunuzun fotoğrafları için izninize ihtiyacımız var.'),
              ),
              const Gap(16),
              ElevatedButton(
                onPressed: () async {
                  await PhotoManager.openSetting();
                  final PermissionState ps =
                      await PhotoManager.requestPermissionExtend();
                  if (ps == PermissionState.authorized) {
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
}

class ImagePreviewSlider extends ConsumerStatefulWidget {
  const ImagePreviewSlider({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ImagePreviewSliderState();
}

class _ImagePreviewSliderState extends ConsumerState<ImagePreviewSlider> {
  late CarouselController controller;

  @override
  void initState() {
    super.initState();
    controller = CarouselController();
    controller.onReady.then((_) {
      ref.read(newPawLogicProvider.notifier).setController(controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<AssetEntity> assets =
        ref.watch(newPawLogicProvider).assets ?? <AssetEntity>[];
    return Container(
      color: Colors.black,
      width: context.width,
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              debugPrint('back');
              controller.previousPage();
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          const Gap(16),
          Expanded(
            child: CarouselSlider(
              carouselController: controller,
              items: assets
                  .map((AssetEntity e) => FutureBuilder<Uint8List?>(
                        future: e.originBytes,
                        builder: (_, AsyncSnapshot<Uint8List?> snapshot) {
                          final Uint8List? bytes = snapshot.data;
                          // If we have no data, display a spinner
                          if (bytes == null)
                            return const Center(
                                child: CircularProgressIndicator.adaptive());
                          // If there's data, display it as an image
                          return CachedMemoryImage(
                            uniqueKey: e.id,
                            bytes: bytes,
                            fit: BoxFit.fitHeight,
                          );
                        },
                      ))
                  .toList(),
              options: CarouselOptions(
                  viewportFraction: 1, enableInfiniteScroll: false, aspectRatio: 1),
            ),
          ),
          const Gap(16),
          IconButton(
            onPressed: () {
              debugPrint('next');
              controller.nextPage();
            },
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class GalleryListBuilder extends ConsumerWidget {
  const GalleryListBuilder({
    super.key,
    required this.onTap,
  });

  final Function(AssetEntity)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<AssetEntity>> images = ref.watch(fetchImagesProvider);
    return images.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, StackTrace? stackTrace) =>
          const Center(child: CircularProgressIndicator()),
      data: (List<AssetEntity> images) {
        final List<Widget> assetList = images
            .map((AssetEntity e) => AssetThumbnail(
                  asset: e,
                  onTap: () {
                    debugPrint('tapped');
                    ref.read(newPawLogicProvider.notifier).addImage(e);
                    onTap?.call(e);
                  },
                ))
            .toList();
        final List<Widget> cameraAndGallery = <Widget>[];
        cameraAndGallery.add(
          GestureDetector(
            onTap: () {},
            child: const CameraWidget(),
          ),
        );
        cameraAndGallery.add(
          GestureDetector(
            onTap: () {},
            child: const GalleryWidget(),
          ),
        );
        cameraAndGallery.addAll(assetList);
        return SizedBox(
          width: context.width,
          height: context.height,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Expanded(
                  flex: 2,
                  child: ImagePreviewSlider(),
                ),
                Expanded(
                  flex: 4,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: cameraAndGallery.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        child: cameraAndGallery[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AssetThumbnail extends ConsumerWidget {
  const AssetThumbnail({
    super.key,
    required this.asset,
    this.isSelected = false,
    this.onTap,
  });

  final AssetEntity asset;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NewPawUiModel newPawUiModel = ref.watch(newPawLogicProvider);
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailData,
      builder: (_, AsyncSnapshot<Uint8List?> snapshot) {
        final Uint8List? bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null) return const CircularProgressIndicator();
        // If there's data, display it as an image
        return InkWell(
          onTap: () {
            onTap?.call();
          },
          child: SizedBox(
            child: Stack(
              children: <Widget>[
                CachedMemoryImage(
                    uniqueKey: asset.id,
                    bytes: bytes,
                    fit: BoxFit.fitWidth,
                    width: 300,
                    height: 300),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Visibility(
                        visible: newPawUiModel.assets?.contains(asset) ?? false,
                        child: const Icon(Icons.check, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CameraWidget extends StatelessWidget {
  const CameraWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorScheme.primary,
      child: const Center(
        child: Icon(Icons.camera_alt, color: Colors.black, size: 42),
      ),
    );
  }
}

class GalleryWidget extends StatelessWidget {
  const GalleryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        
      },
      child: Container(
        color: context.colorScheme.primary,
        child: const Center(
          child: Icon(Icons.photo_library, color: Colors.black, size: 42),
        ),
      ),
    );
  }
}
