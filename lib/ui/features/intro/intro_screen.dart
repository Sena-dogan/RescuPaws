import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../constants/assets.dart';
import '../../../utils/context_extensions.dart';
import '../../widgets/app_bar_gone.dart';

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
                onPressed: () {},
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

class NextButton extends StatelessWidget {
  const NextButton({super.key, required this.onPressed});
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 79.44,
      height: 80,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: 68,
              height: 68,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: <Color>[
                    // #EF7E06, #F7B327
                    Color(0xFFEF7E06),
                    Color(0xFFF7B327),
                  ])),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
              right: -1,
              top: -1,
              child: SizedBox(
                child: ArcWidget(),
              )),
        ],
      ),
    );
  }
}

class ArcWidget extends StatelessWidget {
  const ArcWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.Arc,
      width: 50,
      height: 50,
    );
  }
}
