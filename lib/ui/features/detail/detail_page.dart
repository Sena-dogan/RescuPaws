// ignore_for_file: avoid_field_initializers_in_const_classes, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rescupaws/models/paw_entry_detail.dart';
import 'package:rescupaws/ui/features/detail/logic/detail_logic.dart';
import 'package:rescupaws/ui/features/detail/widgets/detail_body.dart';
import 'package:rescupaws/ui/home/widgets/loading_paw_widget.dart';
import 'package:rescupaws/ui/widgets/add_nav_button.dart';
import 'package:rescupaws/ui/widgets/bottom_nav_bar.dart';
import 'package:rescupaws/utils/context_extensions.dart';
import 'package:rescupaws/utils/error_widgett.dart';

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
    AsyncValue<GetPawEntryDetailResponse?> pawEntryDetailResponse =
        ref.watch(fetchPawEntryDetailProvider(id.toString()));
    Size size = MediaQuery.sizeOf(context);
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
         gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            context.colorScheme.surface,
            context.colorScheme.primaryContainer,
          ],
        ),
      ),
      child: Scaffold(
        body: switch (pawEntryDetailResponse) {
          AsyncData<GetPawEntryDetailResponse?>(
            :GetPawEntryDetailResponse? value
          ) =>
            DetailBody(
              pinned: _pinned,
              pawEntryDetailResponse: value,
              size: size,
            ),
          AsyncValue<Object?>(:Object error?) => PawErrorWidget(
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
        bottomNavigationBar: const PawBottomNavBar(),
      ),
    );
  }
}
