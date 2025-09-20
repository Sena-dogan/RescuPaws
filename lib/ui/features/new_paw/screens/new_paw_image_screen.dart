import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rescupaws/config/router/app_router.dart';
import 'package:rescupaws/constants/assets.dart';
import 'package:rescupaws/ui/features/new_paw/logic/new_paw_logic.dart';
import 'package:rescupaws/utils/context_extensions.dart';

class NewPawImageScreen extends ConsumerStatefulWidget {
  const NewPawImageScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewPawImageScreenState();
}

class _NewPawImageScreenState extends ConsumerState<NewPawImageScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    AsyncValue<PermissionState> ps =
        ref.read(fetchPermissionStateProvider);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            context.colorScheme.surface,
            context.colorScheme.primaryContainer,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ps.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace? stackTrace) =>
              const Center(child: CircularProgressIndicator()),
          data: (PermissionState ps) {
            if (mounted &&
                (ps == PermissionState.authorized ||
                    ps == PermissionState.limited)) {
              _showImagePickerOptions(context);
            }
            return _handleError(context);
          },
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galeriden Seç'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _pickMultipleImages();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Kamera'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _takePicture();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text('İptal'),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.pop(); // Go back to previous screen
                  },
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Future<void> _pickMultipleImages() async {
    try {
      // For multiple image selection, we'll use single image picker multiple times
      // or show a different UI. For now, let's pick one at a time
      XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        AssetEntity asset = await PhotoManager.editor.saveImageWithPath(
          pickedFile.path,
          title: 'paw_${DateTime.now().millisecondsSinceEpoch}',
        );

        await ref
            .read(newPawLogicProvider.notifier)
            .addAssets(<AssetEntity>[asset]).then((_) async {
          debugPrint('gallery asset added');
          if (!context.mounted && !mounted) return false;
          await context.push(SGRoute.newpaw.route);
        });
            }
    } catch (e) {
      debugPrint('Error picking images: $e');
      if (context.mounted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fotoğraf seçilirken bir hata oluştu')),
        );
      }
    }
  }

  Future<void> _takePicture() async {
    try {
      XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85, 
      );

      if (pickedFile != null) {
        AssetEntity asset = await PhotoManager.editor.saveImageWithPath(
          pickedFile.path,
          title: 'paw_${DateTime.now().millisecondsSinceEpoch}',
        );

        await ref
            .read(newPawLogicProvider.notifier)
            .addAssets(<AssetEntity>[asset]).then((_) async {
          debugPrint('camera asset added');
          if (!context.mounted && !mounted) return false;
          await context.push(SGRoute.newpaw.route);
        });
            }
    } catch (e) {
      debugPrint('Error taking picture: $e');
      if (context.mounted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fotoğraf çekilirken bir hata oluştu')),
        );
      }
    }
  }

  Widget _handleError(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            context.colorScheme.surface,
            context.colorScheme.primaryContainer,
          ],
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
                padding: EdgeInsets.all(8),
                child: Text(
                    'Patili dostunuzun fotoğrafları için izninize ihtiyacımız var.'),
              ),
              const Gap(16),
              ElevatedButton(
                onPressed: () async {
                  await PhotoManager.openSetting();
                  PermissionState ps =
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
