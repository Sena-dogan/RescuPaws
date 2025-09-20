import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rescupaws/config/router/app_router.dart';
import 'package:rescupaws/constants/assets.dart';

class AddNavButton extends StatelessWidget {
  const AddNavButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      height: 75,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () {
            context.push(SGRoute.breed.route);
          },
          clipBehavior: Clip.antiAlias,
          // Shape of 4 edged circle rotated 45 degrees
          shape: const StarBorder.polygon(
            sides: 4,
            rotation: 90,
            pointRounding: 0.7,
          ),
          child: Image.asset(
            Assets.paw,
            width: 40,
            height: 40,
          ),
        ),
      ),
    );
  }
}
