import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheel_slider/wheel_slider.dart';

import '../../../../utils/context_extensions.dart';

class WheelBox extends StatelessWidget {
  const WheelBox({super.key, required this.wheelSlider, this.valueText});
  final WheelSlider wheelSlider;
  final Text? valueText;

  @override
  Widget build(BuildContext context) {
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
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: context.colorScheme.secondaryContainer,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Kg',
                  style: context.textTheme.labelSmall,
                ),
              ),
            ),
            const Gap(20.0),
            TextButton(
              onPressed: () {},
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
