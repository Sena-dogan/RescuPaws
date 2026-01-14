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
import 'package:rescupaws/ui/features/new_paw/widgets/image_preview_grid.dart';
import 'package:rescupaws/utils/context_extensions.dart';

class ImageManagementScreen extends ConsumerStatefulWidget {
  const ImageManagementScreen({super.key});

  @override
  ConsumerState<ImageManagementScreen> createState() => _ImageManagementScreenState();
}

class _ImageManagementScreenState extends ConsumerState<ImageManagementScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<bool> _onWillPop(BuildContext context, int imageCount) async {
    if (imageCount == 0) {
      // Show confirmation if no images selected
      bool? shouldLeave = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Fotoğraf Eklemediniz'),
            content: const Text('En az bir fotoğraf eklemeden çıkmak istediğinize emin misiniz?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Kal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Çık'),
              ),
            ],
          );
        },
      );
      return shouldLeave ?? false;
    }
    return true;
  }

  void _showImagePickerOptions() {
    showModalBottomSheet<void>(
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
                  await _pickImageFromGallery();
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
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
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
            .addAssets(assets: <AssetEntity>[asset]);
        debugPrint('gallery asset added');
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
            .addAssets(assets: <AssetEntity>[asset]);
        debugPrint('camera asset added');
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
      if (context.mounted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fotoğraf çekilirken bir hata oluştu'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildPermissionError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Lottie.asset(
              Assets.Error,
              repeat: true,
              height: 200,
            ),
            const Gap(16),
            Text(
              'Patili dostunuzun fotoğrafları için izninize ihtiyacımız var.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge,
            ),
            const Gap(24),
            ElevatedButton.icon(
              onPressed: () async {
                await PhotoManager.openSetting();
                PermissionState ps = await PhotoManager.requestPermissionExtend();
                if (ps == PermissionState.authorized || ps == PermissionState.limited) {
                  setState(() {}); // Refresh UI
                }
              },
              icon: const Icon(Icons.settings),
              label: const Text('İzin Ver'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int imageCount = ref.watch(newPawLogicProvider).assets?.length ?? 0;
    
    return PopScope(
      canPop: imageCount > 0,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!didPop) {
          bool shouldPop = await _onWillPop(context, imageCount);
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Container(
      constraints: const BoxConstraints.expand(),
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Fotoğraf Yönetimi',
            style: context.textTheme.titleLarge,
          ),
          leading: IconButton(
            icon: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: FutureBuilder<PermissionState>(
          future: PhotoManager.requestPermissionExtend(),
          builder: (BuildContext context, AsyncSnapshot<PermissionState> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            PermissionState ps = snapshot.data ?? PermissionState.denied;
            
            // Show permission error if not authorized
            if (ps != PermissionState.authorized && ps != PermissionState.limited) {
              return _buildPermissionError();
            }

            // Show initial picker if no images
            if (imageCount == 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _showImagePickerOptions();
                }
              });
            }

            return Column(
              children: <Widget>[
                Expanded(
                  child: ImagePreviewGrid(
                    onAddMore: _showImagePickerOptions,
                  ),
                ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (imageCount == 0)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const Gap(8),
                            Expanded(
                              child: Text(
                                'Devam etmek için en az 1 fotoğraf eklemelisiniz',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: Colors.orange[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Gap(12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: imageCount > 0
                            ? () {
                                // Navigate to breed selection first
                                context.push(SGRoute.newpaw.route);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colorScheme.primary,
                          disabledBackgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Devam Et',
                          style: context.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
              ],
            );
          },
        ),
      ),
      ),
    );
  }
}
