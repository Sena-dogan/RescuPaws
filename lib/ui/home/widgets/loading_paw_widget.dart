import 'package:flutter/material.dart';

import 'package:rescupaws/constants/assets.dart';
import 'package:rescupaws/utils/context_extensions.dart';

class LoadingPawWidget extends StatelessWidget {
  const LoadingPawWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width * 0.25,
      height: size.height * 0.25,
      child: Image.asset(
        Assets.LoadingPaw,
        color: context.colorScheme.primary,
      ),
    );
  }
}
