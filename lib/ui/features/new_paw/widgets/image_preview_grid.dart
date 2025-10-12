import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:rescupaws/ui/features/new_paw/logic/new_paw_logic.dart';
import 'package:rescupaws/utils/context_extensions.dart';

class ImagePreviewGrid extends ConsumerStatefulWidget {
  const ImagePreviewGrid({
    super.key,
    this.onAddMore,
  });

  final VoidCallback? onAddMore;

  @override
  ConsumerState<ImagePreviewGrid> createState() => _ImagePreviewGridState();
}

class _ImagePreviewGridState extends ConsumerState<ImagePreviewGrid> {
  @override
  Widget build(BuildContext context) {
    List<AssetEntity> assets = ref.watch(newPawLogicProvider).assets ?? <AssetEntity>[];
    bool isLoading = ref.watch(newPawLogicProvider).isImageLoading;

    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Gap(16),
            Text('Fotoğraflar hazırlanıyor...'),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Fotoğraflar (${assets.length}/5)',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (assets.length < 5)
                TextButton.icon(
                  onPressed: widget.onAddMore,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Ekle'),
                ),
            ],
          ),
        ),
        if (assets.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.photo_library_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const Gap(16),
                  Text(
                    'Henüz fotoğraf eklemediniz',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const Gap(8),
                  ElevatedButton.icon(
                    onPressed: widget.onAddMore,
                    icon: const Icon(Icons.add_a_photo),
                    label: const Text('Fotoğraf Ekle'),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: assets.length,
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  List<AssetEntity> updatedAssets = List<AssetEntity>.from(assets);
                  AssetEntity item = updatedAssets.removeAt(oldIndex);
                  updatedAssets.insert(newIndex, item);
                  ref.read(newPawLogicProvider.notifier).setImages(updatedAssets);
                });
              },
              itemBuilder: (BuildContext context, int index) {
                AssetEntity asset = assets[index];
                return Card(
                  key: ValueKey<String>(asset.id),
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: AssetEntityImage(
                            asset,
                            isOriginal: false,
                            fit: BoxFit.cover,
                            thumbnailSize: const ThumbnailSize.square(500),
                            errorBuilder: (BuildContext context, Object error, StackTrace? stack) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.broken_image, size: 48),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // Badge showing image order
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: index == 0 
                                ? context.colorScheme.primary 
                                : Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (index == 0)
                                const Icon(Icons.star, size: 14, color: Colors.white)
                              else
                                Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              if (index == 0) ...<Widget>[
                                const Gap(4),
                                const Text(
                                  'Ana Fotoğraf',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      // Drag handle
                      Positioned(
                        top: 8,
                        right: 48,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.drag_handle,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      // Delete button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              bool? confirm = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Fotoğrafı Sil'),
                                    content: const Text('Bu fotoğrafı silmek istediğinize emin misiniz?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text('İptal'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: const Text('Sil'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if ((confirm ?? false) && mounted) {
                                ref.read(newPawLogicProvider.notifier).addImage(asset);
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        if (assets.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: context.colorScheme.primary,
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      'Fotoğrafları sürükleyerek sıralamayı değiştirebilirsiniz. İlk fotoğraf ana fotoğraf olarak görünecektir.',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
