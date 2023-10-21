import 'package:flutter/material.dart';

class ScaffoldWithBackground extends StatelessWidget {
  const ScaffoldWithBackground(
      {super.key, required this.imagePath, required this.scaffold});
  final String imagePath;
  final Scaffold scaffold;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: scaffold,
    );
  }
}
