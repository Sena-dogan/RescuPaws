// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../../../../config/router/app_router.dart';
import '../../../../constants/assets.dart';
import '../../../../models/categories_response.dart';
import '../../../../utils/context_extensions.dart';
import '../../../home/widgets/loading_paw_widget.dart';
import '../logic/new_paw_logic.dart';

class SelectSubBreedWidget extends ConsumerWidget {
  const SelectSubBreedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Category>> categories = ref.watch(
        fetchSubCategoriesProvider(ref.read(newPawLogicProvider).category_id!));
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              'Cins Seç',
              style: context.textTheme.labelSmall,
            ),
          ),
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
                        child: SearchableList<Category>(
                      initialList: data,
                      itemBuilder: (Category item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.pets),
                              title: Text(item.name),
                              onTap: () {
                                ref
                                    .read(newPawLogicProvider.notifier)
                                    .setSubCategoryId(item.id);
                                Navigator.pop(context, item.name);
                              },
                            ),
                          ),
                        );
                      },
                      emptyWidget: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Lottie.asset(
                                  Assets.NotFound,
                                  repeat: true,
                                  height: 200,
                                ),
                              ),
                            ),
                            Text(
                              'Aradığınız kategori bulunamadı.',
                              style: context.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      inputDecoration: InputDecoration(
                        hintText: 'Bir kategori arayın..',
                        hintStyle: context.textTheme.bodyMedium,
                        constraints: BoxConstraints.tight(
                          const Size.fromHeight(60),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      filter: (String query) {
                        return data
                            .where((Category element) => element.name
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                            .toList();
                      },
                      errorWidget: const SizedBox(),
                    )),
                  ],
                ),
              );
            },
            error: (Object error, StackTrace stackTrace) => Center(
              child: Text(error.toString()),
            ),
            loading: () => const Center(
              child: LoadingPawWidget(),
            ),
          ),
        ));
  }
}
