import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rescupaws/ui/features/new_paw/logic/new_paw_logic.dart';
import 'package:rescupaws/utils/context_extensions.dart';
import 'package:wheel_slider/wheel_slider.dart';

class WheelBox extends ConsumerWidget {
  const WheelBox({
    super.key,
    required this.wheelSlider,
    this.valueText,
  });

  final WheelSlider wheelSlider;
  final Text? valueText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.sizeOf(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Evcil Hayvanınızın Kilosu Nedir?',
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.scrim,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Gap(16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: <Widget>[
                wheelSlider,
                valueText ?? Container(),
              ],
            ),
          ),
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MeasureWidget(
              text: 'Kg',
              color: ref.watch(newPawLogicProvider).isKg
                  ? context.colorScheme.secondaryContainer
                  : Colors.grey.shade400,
              onPressed: () {
                ref.read(newPawLogicProvider.notifier).setWeightMeasure();
              },
            ),
            Gap(size.width * 0.1),
            MeasureWidget(
              text: 'Lb',
              color: ref.watch(newPawLogicProvider).isKg
                  ? Colors.grey.shade400
                  : context.colorScheme.secondaryContainer,
              onPressed: () {
                ref.read(newPawLogicProvider.notifier).setWeightMeasure();
              },
            ),
          ],
        ),
      ],
    );
  }
}

class MeasureWidget extends ConsumerWidget {
  const MeasureWidget({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  final String text;
  final Color color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      height: 60,
      width: size.width * 0.3,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: color,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: context.textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
