import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheel_slider/wheel_slider.dart';

import '../../../../utils/context_extensions.dart';
import '../logic/new_paw_logic.dart';

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
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Evcil Hayvanınızın Kilosu Nedir?',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Gap(20.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: <Widget>[
                wheelSlider,
                valueText ?? Container(),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MeasureWidget(
              text: 'Kg',
              color: ref.watch(newPawLogicProvider).isKg
                  ? context.colorScheme.secondaryContainer
                  : Colors.grey,
              onPressed: () {
                ref.read(newPawLogicProvider.notifier).setKg(true);
              },
            ),
            Gap(size.width * 0.1),
            MeasureWidget(
              text: 'Lb',
              color: ref.watch(newPawLogicProvider).isLb
                  ? context.colorScheme.secondaryContainer
                  : Colors.grey,
              onPressed: () {
                ref.read(newPawLogicProvider.notifier).setLb(true);
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
  final Function()? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: 60,
      width: size.width * 0.3,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: color,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: context.textTheme.labelSmall?.copyWith(
            color: color,
          ),
        ),
      ),
    );
  }
}
