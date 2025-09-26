import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import 'package:rescupaws/utils/context_extensions.dart';

class LeftButton extends StatelessWidget {
  const LeftButton({
    super.key,
    required this.controller,
  });

  final CardSwiperController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 110,
      decoration: ShapeDecoration(
        shadows: const <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            offset: Offset(0, 3),
            blurRadius: 6,
          )
        ],
        color: Colors.white,
        shape: StarBorder.polygon(
          side: BorderSide(
            color: context.colorScheme.outlineVariant,
          ),
          pointRounding: 0.3,
          sides: 3,
          // left rotation
          rotation: 270,
        ),
      ),
      child: InkWell(
        onTap: () {
          debugPrint('Tapped left');
          controller.swipe(CardSwiperDirection.left);
        },
        customBorder: StarBorder.polygon(
          side: BorderSide(
            color: Colors.black.withValues(alpha:0.17),
          ),
          pointRounding: 0.3,
          sides: 3,
          // left rotation
          rotation: 270,
        ),
        splashFactory: NoSplash.splashFactory,
        child: Icon(
          // X icon
          Icons.close,
          size: 25,
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}
