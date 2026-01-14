import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_manager/src/types/entity.dart';
import 'package:rescupaws/config/router/app_router.dart';
import 'package:rescupaws/constants/assets.dart';
import 'package:rescupaws/models/new_paw_model.dart';
import 'package:rescupaws/models/paw_entry.dart';
import 'package:rescupaws/ui/features/new_paw/logic/new_paw_logic.dart';
import 'package:rescupaws/ui/features/new_paw/model/new_paw_ui_model.dart';
import 'package:rescupaws/ui/home/widgets/loading_paw_widget.dart';
import 'package:rescupaws/utils/context_extensions.dart';

class NewPawScreen extends ConsumerStatefulWidget {
  const NewPawScreen({super.key});

  @override
  ConsumerState<NewPawScreen> createState() => _NewPawScreenState();
}

class _NewPawScreenState extends ConsumerState<NewPawScreen> {
  late final PawEntry _pawEntry;
  late final List<AssetEntity> _imageAssets;
  
  @override
  void initState() {
    super.initState();
    // Capture the parameters once at initialization
    NewPawUiModel newPawUiModel = ref.read(newPawLogicProvider);
    _pawEntry = newPawUiModel.toPawEntry();
    _imageAssets = newPawUiModel.assets ?? <AssetEntity>[];
  }

  @override
  Widget build(BuildContext context) {
    // Now watch with stable parameters that won't change
    AsyncValue<NewPawResponse> createPawEntry = ref.watch(
      createPawEntryProvider(_pawEntry, _imageAssets),
    );
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'İlan Oluşturuluyor',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false, // Remove back button to prevent navigation during upload
        ),
        body: createPawEntry.when(
          data: (NewPawResponse data) {
            // Success state - Navigate back after delay
            Future<void>.delayed(const Duration(seconds: 3), () {
              if (!context.mounted) return;
              context.go(SGRoute.home.route);
            });
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Lottie.asset(
                  Assets.Success,
                  repeat: true,
                  height: 300,
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Tebrikler! Kayıt başarılı',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'İlanınız yayınlandı',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            );
          },
          loading: () {
            // Loading state - uploading images and creating entry
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: context.width * 0.4,
                    height: context.height * 0.4,
                    child: const LoadingPawWidget(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Fotoğraflar yükleniyor...',
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lütfen bekleyin',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          },
          error: (Object error, StackTrace stackTrace) {
            // Error state - Navigate back after delay
            Future<void>.delayed(const Duration(seconds: 3), () {
              if (!context.mounted) return;
              ref.invalidate(newPawLogicProvider);
              context.go(SGRoute.home.route);
            });
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Lottie.asset(
                  Assets.Error,
                  repeat: true,
                  height: 200,
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Bir hata oluştu',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.red[700],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
