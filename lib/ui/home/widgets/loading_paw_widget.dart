import 'package:flutter/material.dart';

import '../../../constants/assets.dart';

class LoadingPawWidget extends StatelessWidget {
  const LoadingPawWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
          Assets.LoadingPaw,
        );
  }
}
