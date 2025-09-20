import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:rescupaws/config/router/app_router.dart';
import 'package:rescupaws/constants/assets.dart';
import 'package:rescupaws/models/new_paw_model.dart';
import 'package:rescupaws/ui/features/new_paw/logic/new_paw_logic.dart';
import 'package:rescupaws/ui/features/new_paw/model/new_paw_ui_model.dart';
import 'package:rescupaws/ui/home/widgets/loading_paw_widget.dart';
import 'package:rescupaws/utils/context_extensions.dart';

class NewPawScreen extends ConsumerWidget {
  const NewPawScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NewPawUiModel newPawUiModel = ref.watch(newPawLogicProvider);
  AsyncValue<NewPawResponse> createPawEntry =
    ref.watch(createPawEntryProvider(newPawUiModel.toPawEntry()));
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
        body: createPawEntry.when(data: (NewPawResponse data) {
          Future<void>.delayed(const Duration(seconds: 3), () {
            ref.invalidate(newPawLogicProvider);
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
              Center(
                child: Text('Tebrikler. Kayıt başarılı',
                    style: context.textTheme.titleLarge),
              ),
            ],
          );
        }, error: (Object error, StackTrace stackTrace) {
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
              Center(
                child: Text('Bir hata oluştu.',
                    style: context.textTheme.titleLarge),
              ),
            ],
          );
        }, loading: () {
          return Center(
            child: SizedBox(
                width: context.width * 0.4,
                height: context.height * 0.4,
                child: const LoadingPawWidget()),
          );
        }),
      ),
    );
  }
}
