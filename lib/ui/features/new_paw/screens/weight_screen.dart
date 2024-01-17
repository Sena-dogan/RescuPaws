import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wheel_slider/wheel_slider.dart';

import '../../../../config/router/app_router.dart';
import '../../../../constants/assets.dart';
import '../../../../utils/context_extensions.dart';
import '../logic/new_paw_logic.dart';
import '../widgets/custom_box.dart';

class WeightScreen extends ConsumerWidget {
  const WeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const int totalCount = 10;
    const num initValue = 0.5;
    const num currentValue = 0.5;

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Evcil Hayvanınızın Kilosu Nedir?',
                style: context.textTheme.labelMedium,
              ),
              CustomBox(
                wheelSlider: WheelSlider(
                  totalCount: totalCount,
                  initValue: initValue,
                  onValueChanged: (dynamic value) {
                    ref
                        .read(newPawLogicProvider.notifier)
                        .setPawWeight(value as num);
                  },
                  pointerColor: context.colorScheme.primary,
                ),
                valueText: Text(
                  currentValue.toString(),
                  style: const TextStyle(
                    fontSize: 18.0,
                    height: 2.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.push(SGRoute.address.route);
                },
                child: const Text('Continue'),
              ),
            ],
          )),
    );
  }
}
