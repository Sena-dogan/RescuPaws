import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_router.dart';
import '../../../../constants/assets.dart';
import '../../../../models/categories_response.dart';
import '../../../../utils/context_extensions.dart';
import '../logic/new_paw_logic.dart';

class SelectBreedScreen extends ConsumerStatefulWidget {
  const SelectBreedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewPawScreenState();
}

class _NewPawScreenState extends ConsumerState<SelectBreedScreen> {
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
          appBar: AppBar(),
          backgroundColor: Colors.transparent,
          body: categories.when(
            data: (List<Category> data) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Gap(16),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              ref
                                  .read(newPawLogicProvider.notifier)
                                  .setCategoryId(data[index].id);
                              context.push(SGRoute.subbreed.route);
                            },
                            child: Card(
                              child: Center(
                                child: Text(data[index].name),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
