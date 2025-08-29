import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../config/router/app_router.dart';
import '../../../constants/assets.dart';
import '../../../utils/context_extensions.dart';
import '../../widgets/app_bar_gone.dart';
import 'widgets/next_button.dart';

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          // image: const DecorationImage(
          //   image: AssetImage(Assets.LoginBg),
          //   fit: BoxFit.cover,
          // ),
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
          appBar: const EmptyAppBar(),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              children: <Widget>[
                const Gap(25),
                Image.asset(
                  Assets.RescuPaws,
                  width: 200,
                  color: context.colorScheme.primary,
                ),
                const Gap(39),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Minik Bir Dost,\n',
                    style: context.textTheme.labelLarge,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sonsuz Bir Sevgi',
                        style: context.textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
                const Gap(12),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Sahiplen, kalbindeki boşluğu doldur!\n',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.scrim,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Minik patilerle tanışmaya hazır mısınız?',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.scrim,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(25),
                NextButton(
                  onPressed: () {
                    /// Uncomment this to save intro state
                    /// For now, we are not saving intro state
                    /// because we want to show intro screen every time
                    /// user opens the app
                    ///
                    // final GetStoreHelper getStoreHelper = getIt<GetStoreHelper>();
                    // getStoreHelper.saveIntro(true);
                    debugPrint('Intro button pressed');
                    context.go(SGRoute.home.route);
                  },
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    Assets.Dog,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
