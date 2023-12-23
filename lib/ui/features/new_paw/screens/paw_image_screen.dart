import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../constants/assets.dart';
import '../../../../utils/context_extensions.dart';
import '../logic/new_paw_logic.dart';

class PawImageScreen extends ConsumerStatefulWidget {
  const PawImageScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PawImageScreenState();
}

class _PawImageScreenState extends ConsumerState<PawImageScreen> {
  @override
  Widget build(BuildContext context) {
    var newPawLogic = ref.watch(newPawLogicProvider);
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        image: const DecorationImage(
          image: AssetImage(Assets.LoginBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
          ],
        ),
      ),
    );
  }
}
