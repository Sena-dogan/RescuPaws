import 'package:flutter/material.dart';

class ImageLineIndicator extends StatelessWidget {
  const ImageLineIndicator({
    super.key,
    required this.numberOfImages,
    this.spacing = 4.0,
  });
  final int numberOfImages;
  final double spacing;

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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              )),
    );
  }
}
