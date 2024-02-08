import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/assets.dart';
import '../../../models/paw_entry_detail.dart';
import '../../../utils/context_extensions.dart';
import '../../../utils/error_widgett.dart';
import '../../home/widgets/loading_paw_widget.dart';
import 'logic/detail_logic.dart';

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
            AsyncValue<Object?>(:final Object error?) => ErrorWidgett(
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

class VaccineBody extends StatelessWidget {
  const VaccineBody({
    super.key,
    required this.pawEntryDetailResponse,
  });

  final GetPawEntryDetailResponse? pawEntryDetailResponse;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              HaveVaccineWidget(
                title: 'Rabies Aşısı',
                haveVaccine: pawEntryDetailResponse!.data!.rabies_vaccine ?? 2,
              ),
              HaveVaccineWidget(
                title: 'Distemper Aşısı',
                haveVaccine:
                    pawEntryDetailResponse!.data!.distemper_vaccine ?? 2,
              ),
              HaveVaccineWidget(
                title: 'Hepatitis Aşısı',
                haveVaccine:
                    pawEntryDetailResponse!.data!.hepatitis_vaccine ?? 2,
              ),
              HaveVaccineWidget(
                title: 'Parvovirus Aşısı',
                haveVaccine:
                    pawEntryDetailResponse!.data!.parvovirus_vaccine ?? 2,
              ),
              HaveVaccineWidget(
                title: 'Bordotella Aşısı',
                haveVaccine:
                    pawEntryDetailResponse!.data!.bordotella_vaccine ?? 2,
              ),
              HaveVaccineWidget(
                title: 'Leptospirosis Aşısı',
                haveVaccine:
                    pawEntryDetailResponse!.data!.leptospirosis_vaccine ?? 2,
              ),
              HaveVaccineWidget(
                title: 'Panleukopenia Aşısı',
                haveVaccine:
                    pawEntryDetailResponse!.data!.panleukopenia_vaccine ?? 2,
              ),
              HaveVaccineWidget(
                title: 'Herpesvirus and Calicivirus Aşısı',
                haveVaccine: pawEntryDetailResponse!
                        .data!.herpesvirus_and_calicivirus_vaccine ??
                    2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HaveVaccineWidget extends StatelessWidget {
  const HaveVaccineWidget({
    required this.title,
    required this.haveVaccine,
    super.key,
  });

  final String title;
  final int haveVaccine;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: haveVaccine == 1
                ? Colors.green.withOpacity(0.4)
                : haveVaccine == 0
                    ? Colors.red.withOpacity(0.4)
                    : Colors.grey.withOpacity(0.4),
            width: 2,
          ),
        ),
        child: ListTile(
          title: Text(
            title,
            style: context.textTheme.bodyLarge,
            selectionColor: context.colorScheme.scrim,
          ),
          trailing: haveVaccine == 1
              ? const Icon(
                  Icons.check,
                  color: Colors.green,
                )
              : haveVaccine == 0
                  ? const Icon(
                      Icons.close,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.help,
                      color: Colors.grey,
                    ),
        ),
      ),
    );
  }
}
