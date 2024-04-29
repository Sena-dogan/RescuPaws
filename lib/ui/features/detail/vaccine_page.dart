import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/assets.dart';
import '../../../models/paw_entry_detail.dart';
import '../../../utils/context_extensions.dart';
import '../../../utils/error_widgett.dart';
import '../../home/widgets/loading_paw_widget.dart';
import 'logic/detail_logic.dart';
import 'widgets/vaccine_body_detail.dart';

class VaccineScreen extends ConsumerWidget {
  const VaccineScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<GetPawEntryDetailResponse?> pawEntryDetailResponse =
        ref.watch(fetchPawEntryDetailProvider(id.toString()));
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
          body: switch (pawEntryDetailResponse) {
            AsyncData<GetPawEntryDetailResponse?>(
              :final GetPawEntryDetailResponse? value
            ) =>
              VaccineBody(
                pawEntryDetailResponse: value,
              ),
            AsyncValue<Object?>(:final Object error?) => PawErrorWidget(
                error: error,
                onRefresh: () async => ref
                    .refresh(fetchPawEntryDetailProvider(id.toString()).future),
              ),
            _ => const Center(
                child: LoadingPawWidget(),
              ),
          },
        ));
  }
}
