import 'package:flutter/material.dart';

import '../../../../constants/assets.dart';
import '../../../../utils/context_extensions.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key, required this.onPressed});
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
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
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: context.colorScheme.primaryFixedDim),
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(0, 17, 11, 11),
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
              ),
            ),
          ],
        ),
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
