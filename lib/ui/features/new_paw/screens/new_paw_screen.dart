import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/router/app_router.dart';
import '../../../../constants/assets.dart';
import '../../../../models/new_paw_model.dart';
import '../../../../utils/context_extensions.dart';
import '../../../home/widgets/loading_paw_widget.dart';
import '../logic/new_paw_logic.dart';
import '../model/new_paw_ui_model.dart';

class NewPawScreen extends ConsumerWidget {
  const NewPawScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NewPawUiModel newPawUiModel = ref.watch(newPawLogicProvider);
    final AsyncValue<NewPawResponse> createPawEntry =
        ref.watch(createPawEntryProvider(newPawUiModel.toNewPawModel()));
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
        body: createPawEntry.when(data: (NewPawResponse data) {
          Future<void>.delayed(const Duration(seconds: 3), () {
            ref.invalidate(newPawLogicProvider);
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
            ref.invalidate(newPawLogicProvider);
            context.go(SGRoute.home.route);
          });
          FirebaseCrashlytics.instance.recordError(error, stackTrace);
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
