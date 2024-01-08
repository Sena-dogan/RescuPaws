import 'package:flutter/material.dart';

import '../../../../utils/context_extensions.dart';

class ImageLineIndicator extends StatelessWidget {
  const ImageLineIndicator({
    super.key,
    required this.numberOfImages,
    required this.selectedIndex,
    this.spacing = 5.0,
    this.unselectedColor = Colors.grey,
  });

  final int numberOfImages;
  final int selectedIndex;
  final double spacing;
  final Color unselectedColor;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        numberOfImages,
        (int index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing / 2),
          child: Container(
            width: (size.width * 0.6) / numberOfImages - spacing,
            height: 5,
            decoration: BoxDecoration(
              color: index == selectedIndex
                  ? context.colorScheme.secondary
                  : unselectedColor,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}
