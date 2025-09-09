import 'package:flutter/material.dart';

import '../../../constants/assets.dart';
import '../../../utils/context_extensions.dart';

class LoadingPawWidget extends StatelessWidget {
  const LoadingPawWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
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
