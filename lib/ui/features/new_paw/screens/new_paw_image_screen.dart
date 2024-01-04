import 'dart:typed_data';

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
              return const GalleryListBuilder();
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
        body: SizedBox(
          width: context.width,
          height: context.height,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                    'Patili dostunuzun fotoğrafları için izninize ihtiyacımız var.'),
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
      ),
    );
  }
}

class GalleryListBuilder extends ConsumerWidget {
  const GalleryListBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<AssetEntity>> images = ref.watch(fetchImagesProvider);
    return images.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, StackTrace? stackTrace) =>
          const Center(child: CircularProgressIndicator()),
      data: (List<AssetEntity> images) {
        return SizedBox(
          width: context.width,
          height: context.height,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder(
                  future: PhotoManager.getAssetListRange(
                    start: 0,
                    end: 20,
                    filterOption: FilterOptionGroup(
                      createTimeCond: DateTimeCond(
                        min: DateTime.now().subtract(const Duration(days: 2)),
                        max: DateTime.now(),
                      ),
                    ),
                  ),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<AssetEntity>> snapshot) {
                    if (snapshot.hasData) {
                      final List<Widget> assetList = snapshot.data!
                          .map((AssetEntity e) => AssetThumbnail(asset: e))
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
                      return Expanded(
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
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    super.key,
    required this.asset,
  });

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailData,
      builder: (_, AsyncSnapshot<Uint8List?> snapshot) {
        final Uint8List? bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null) return const CircularProgressIndicator();
        // If there's data, display it as an image
        return Image.memory(bytes, fit: BoxFit.cover);
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
    return Container(
      color: context.colorScheme.primary,
      child: const Center(
        child: Icon(Icons.photo_library, color: Colors.black, size: 42),
      ),
    );
  }
}
