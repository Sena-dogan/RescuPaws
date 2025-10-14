import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:ionicons/ionicons.dart';
import 'package:rescupaws/utils/context_extensions.dart';

class RightButton extends StatelessWidget {
  const RightButton({
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
        gradient: LinearGradient(
          colors: <Color>[
            context.colorScheme.secondaryContainer,
            context.colorScheme.primaryContainer,
          ],
        ),
        shadows: const <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            offset: Offset(0, 3),
            blurRadius: 6,
          )
        ],
        shape: StarBorder.polygon(
          side: BorderSide(
            color: context.colorScheme.outline,
          ),
          pointRounding: 0.3,
          sides: 3,
          // left rotation
          rotation: 90,
        ),
      ),
      child: InkWell(
        onTap: () {
          debugPrint('Tapped right');
          controller.swipe(CardSwiperDirection.right);
        },
        customBorder: StarBorder.polygon(
          side: BorderSide(
            color: Colors.black.withValues(alpha:0.17000000178813934),
          ),
          pointRounding: 0.3,
          sides: 3,
          // left rotation
          rotation: 90,
        ),
        splashFactory: NoSplash.splashFactory,
        child: const Icon(
          // Paw icon
          Ionicons.heart,
          size: 25,
          color: Colors.white,
        ),
      ),
    );
  }
}
