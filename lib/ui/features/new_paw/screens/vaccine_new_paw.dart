import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/assets.dart';
import '../../../../utils/context_extensions.dart';
import '../widgets/vaccine_create_body.dart';

class VaccinesNewPaw extends ConsumerWidget {
  const VaccinesNewPaw({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: Container(
                height: 50,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                context.pop();
              },
            ),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              'Aşılar',
              style: context.textTheme.labelSmall,
            ),
          ),
          body: const VaccineCreateBody(),
        ));
  }
}
