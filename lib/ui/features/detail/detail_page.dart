// ignore_for_file: avoid_field_initializers_in_const_classes, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/assets.dart';
import '../../../models/paw_entry_detail.dart';
import '../../../utils/context_extensions.dart';
import '../../../utils/error_widgett.dart';
import '../../home/widgets/loading_paw_widget.dart';
import '../../widgets/add_nav_button.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'logic/detail_logic.dart';
import 'widgets/detail_body.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({
    super.key,
    required this.id,
  });

  final int id;
  final bool _pinned = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //AsyncValue<Activity> activity = ref.watch(activityProvider);
    final AsyncValue<GetPawEntryDetailResponse?> pawEntryDetailResponse =
        ref.watch(fetchPawEntryDetailProvider(id.toString()));
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        image: const DecorationImage(
          image: AssetImage(Assets.HomeBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        body: switch (pawEntryDetailResponse) {
          AsyncData<GetPawEntryDetailResponse?>(
            :final GetPawEntryDetailResponse? value
          ) =>
            DetailBody(
              pinned: _pinned,
              pawEntryDetailResponse: value,
              size: size,
            ),
          AsyncValue<Object?>(:final Object error?) => PawErrorWidget(
              error: error,
              onRefresh: () async => ref
                  .refresh(fetchPawEntryDetailProvider(id.toString()).future),
            ),
          _ => Center(
              child: LoadingPawWidget(),
            ),
        },
        floatingActionButton: const AddNavButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}
