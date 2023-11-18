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
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: context.colorScheme.background,
          image: const DecorationImage(
            image: AssetImage(Assets.LoginBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          appBar: const EmptyAppBar(),
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              const Gap(25),
              Image.asset(
                Assets.PatiApp,
                width: 126,
                height: 32,
              ),
              const Gap(39),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Let’s find your pet's ",
                  style: context.textTheme.labelMedium!.copyWith(),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'pawfect match',
                      style: context.textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
              const Gap(12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Meet local dogs and dog lovers for\n',
                  style: context.textTheme.bodyMedium,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'friendship, play-dates or fun outdoor playing.',
                      style: context.textTheme.bodyMedium,
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
                  context.go(SGRoute.firstScreen.route);
                },
              ),
              const Spacer(),
              Image.asset(
                Assets.Dog,
              ),
            ],
          ),
        ));
  }
}
