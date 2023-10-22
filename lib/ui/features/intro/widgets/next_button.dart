import 'package:flutter/material.dart';

import '../../../../constants/assets.dart';

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
                ]),
              ),
              child: ElevatedButton(
                onPressed: onPressed,
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
