// DEPRECATED: This screen has been merged into ImageManagementScreen
// All image picking, permission handling, and image management functionality
// is now handled in a single unified screen: image_management_screen.dart
// This file is kept for reference but should not be used in new code.
// Date: December 2024

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

@Deprecated('Use ImageManagementScreen instead. This screen has been merged into image_management_screen.dart')
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
      // Use multi_image_picker_view instead for better UX
      // For now, let's allow picking images one by one with a better flow
      // Navigate to image management screen where they can add/remove/reorder
      if (!context.mounted || !mounted) return;
      
      // Check current image count
      int currentCount = ref.read(newPawLogicProvider).assets?.length ?? 0;
      
      if (currentCount >= 5) {
        if (context.mounted && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('En fazla 5 fotoğraf ekleyebilirsiniz'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // Show loading indicator
        if (context.mounted && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  Text('Fotoğraf hazırlanıyor...'),
                ],
              ),
              duration: Duration(seconds: 1),
            ),
          );
        }

        AssetEntity asset = await PhotoManager.editor.saveImageWithPath(
          pickedFile.path,
          title: 'paw_${DateTime.now().millisecondsSinceEpoch}',
        );

        await ref
            .read(newPawLogicProvider.notifier)
            .addAssets(assets: <AssetEntity>[asset]).then((_) {
          debugPrint('gallery asset added');
          if (!context.mounted && !mounted) return;
          
          // Navigate to image management screen
          context.pushReplacement(SGRoute.imageManagement.route);
        });
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
      if (context.mounted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fotoğraf seçilirken bir hata oluştu'),
            backgroundColor: Colors.red,
          ),
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
            .addAssets(assets: <AssetEntity>[asset]).then((_) {
          debugPrint('camera asset added');
          if (!context.mounted && !mounted) return;
          context.pushReplacement(SGRoute.imageManagement.route);
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
