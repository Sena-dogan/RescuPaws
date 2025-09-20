import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:rescupaws/constants/assets.dart';
import 'package:rescupaws/utils/context_extensions.dart';

class PawErrorWidget extends StatelessWidget {
  const PawErrorWidget({
    this.error,
    required this.onRefresh,
    super.key,
  });
  final Object? error;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    debugPrint('Error occured while loading paw entries: $error');
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.7,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    Assets.Hearts,
                    width: MediaQuery.sizeOf(context).width * 0.5,
                  ),
                ),
                const Gap(10),
                Text(
                  'Bir sorun oluştu.\n',
                  style: context.textTheme.bodyLarge,
                ),
                //Text('Hata: $error'),
              ]),
        ),
      ),
    );
  }
}
