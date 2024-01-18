import 'package:flutter/material.dart';

import '../../../constants/assets.dart';

class LoadingPawWidget extends StatelessWidget {
  const LoadingPawWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset(
      Assets.LoadingPaw,
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.5,
    ));
  }
}
