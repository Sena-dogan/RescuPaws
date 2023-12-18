import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';

import '../../../../constants/assets.dart';
import '../../../../models/categories_response.dart';
import '../../../../utils/context_extensions.dart';
import '../../../widgets/app_bar_gone.dart';
import '../logic/new_paw_logic.dart';

class NewPawScreen extends ConsumerStatefulWidget {
  const NewPawScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewPawScreenState();
}

class _NewPawScreenState extends ConsumerState<NewPawScreen> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Category>> categories =
        ref.watch(fetchCategoriesProvider);
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
          appBar: const EmptyAppBar(),
          backgroundColor: Colors.transparent,
          body: categories.when(
            data: (List<Category> data) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                ),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Card(
                      child: Center(
                        child: Text(data[index].name),
                      ),
                    ),
                  );
                },
              );
            },
            error: (Object error, StackTrace stackTrace) => Center(
              child: Text(error.toString()),
            ),
            loading: () => const Center(
              child: CupertinoActivityIndicator(),
            ),
          ),
        ));
  }
}
