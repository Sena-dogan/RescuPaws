import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:wheel_slider/wheel_slider.dart';

import '../../../../config/router/app_router.dart';
import '../../../../constants/assets.dart';
import '../../../../utils/context_extensions.dart';
import '../logic/new_paw_logic.dart';
import '../widgets/wheel_box.dart';

class WeightScreen extends ConsumerStatefulWidget {
  const WeightScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeightScreenState();
}

class _WeightScreenState extends ConsumerState<WeightScreen> {
  int totalCount = 1500;
  num initValue = 0;

  @override
  Widget build(BuildContext context) {
    final num currentValue = ref.watch(newPawLogicProvider).weight ?? initValue;
    final Size size = MediaQuery.sizeOf(context);
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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                'Kilo Bilgisi',
                style: context.textTheme.labelSmall,
              )),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Lottie.asset(
                Assets.WorkoutDog,
                height: size.height * 0.3,
              ),
              WheelBox(
                wheelSlider: WheelSlider(
                  interval: 0.1,
                  totalCount: totalCount,
                  initValue: initValue,
                  // ignore: avoid_redundant_argument_values
                  hapticFeedbackType: HapticFeedbackType.heavyImpact,
                  onValueChanged: (dynamic val) {
                    ref
                        .read(newPawLogicProvider.notifier)
                        .setPawWeight(val as num);
                  },
                  pointerColor: context.colorScheme.scrim.withOpacity(0.9),
                  itemSize: 20,
                  perspective: 0.0035,
                  customPointer: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: context.colorScheme.scrim.withOpacity(0.9),
                              width: 1.5,
                            ),
                            color: context.colorScheme.primary,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          Assets.paw,
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                  lineColor: context.colorScheme.primary,
                ),
                valueText: Text(
                  currentValue.toStringAsFixed(1),
                  style: context.textTheme.displayMedium?.copyWith(
                    color: context.colorScheme.scrim.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (currentValue > 0) {
                    context.push(SGRoute.address.route);
                  } else {
                    context.showErrorSnackBar(
                        message: 'Lütfen kilo bilgisini giriniz.');
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      context.colorScheme.primary),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(
                        horizontal: size.width * 0.3, vertical: 15.0),
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: Text(
                  'Devam et',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
