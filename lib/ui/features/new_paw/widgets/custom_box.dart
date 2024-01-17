import 'package:flutter/material.dart';
import 'package:wheel_slider/wheel_slider.dart';

class CustomBox extends StatelessWidget {
  const CustomBox({super.key, required this.wheelSlider, this.valueText});
  final WheelSlider wheelSlider;
  final Text? valueText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Column(
        children: <Widget>[
          wheelSlider,
          valueText ?? Container(),
        ],
      ),
    );
  }
}
