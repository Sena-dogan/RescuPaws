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
    final double screenWidth = MediaQuery.of(context).size.width;
    //final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
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
                width: screenWidth * 0.45,
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
                  style: context.textTheme.bodyMedium,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Minik patilerle tanışmaya hazır mısınız?',
                      style: context.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Gap(25),
              NextButton(
                onPressed: () {
                  debugPrint('Intro button pressed');
                  context.go(SGRoute.home.route);
                },
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Gap(screenWidth * 0.10),
                  Image.asset(
                    Assets.Hearts,
                    width: screenWidth * 0.25,
                  ),
                  const Spacer(),
                  Image.asset(
                    Assets.Dog,
                    width: screenWidth * 0.65,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
