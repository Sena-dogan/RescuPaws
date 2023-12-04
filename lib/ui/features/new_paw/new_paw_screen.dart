import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/assets.dart';
import '../../../utils/context_extensions.dart';
import '../../widgets/app_bar_gone.dart';

class NewPawScreen extends ConsumerStatefulWidget {
  const NewPawScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewPawScreenState();
}

class _NewPawScreenState extends ConsumerState<NewPawScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: context.colorScheme.background,
          image: const DecorationImage(
            image: AssetImage(Assets.LoginBg),
            fit: BoxFit.cover,
          ),
        ),
        child: const Scaffold(
          appBar: EmptyAppBar(),
          backgroundColor: Colors.transparent,
          body: Column(),
        ));
  }
}
