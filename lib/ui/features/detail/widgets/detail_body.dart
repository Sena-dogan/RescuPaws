import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_router.dart';
import '../../../../models/paw_entry_detail.dart';
import '../../../../utils/context_extensions.dart';
import '../logic/detail_logic.dart';
import 'advertiser_info.dart';
import 'characteristics.dart';
import 'paw_image_and_name.dart';

class DetailBody extends ConsumerWidget {
  const DetailBody({
    super.key,
    required bool pinned,
    required this.pawEntryDetailResponse,
    required this.size,
  }) : _pinned = pinned;

  final bool _pinned;
  final GetPawEntryDetailResponse? pawEntryDetailResponse;
  final Size size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pawEntryDetailResponse == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: _pinned,
          leading: IconButton(
            icon: Container(
              height: 50,
              width: 60,
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
            onPressed: () => context.go(SGRoute.home.route),
          ),
          actions: <Widget>[
            IconButton(
              icon: Container(
                height: 50,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.share_outlined,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                ref.read(detailLogicProvider.notifier).shareContent(
                    pawEntryDetailResponse!.pawEntryDetail?.name ?? '');
              },
            ),
            const FavButton(),
          ],
          expandedHeight: MediaQuery.of(context).size.height * 0.5,
          flexibleSpace: PawImageandName(
            pawEntryDetailResponse: pawEntryDetailResponse,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      pawEntryDetailResponse!.pawEntryDetail?.description ?? '',
                      style: context.textTheme.labelSmall,
                    ),
                    const Gap(10),
                    Text(
                      pawEntryDetailResponse!.pawEntryDetail?.address ?? '',
                      style: context.textTheme.bodyMedium,
                    ),
                    const Gap(30),
                    Characteristics(
                      pawEntryDetailResponse: pawEntryDetailResponse,
                    ),
                    const Gap(30),
                    Text(
                      pawEntryDetailResponse!
                              .pawEntryDetail?.createdAtFormatted ??
                          '',
                      style: context.textTheme.bodyMedium,
                    ),
                    const Gap(30),
                    AdvertiserInfo(
                      pawEntryDetailResponse: pawEntryDetailResponse,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(size.width * 0.9, 50),
                          backgroundColor:
                              context.colorScheme.secondaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {},
                        child: Text('Mesaj Gönder',
                            style: context.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ],
                ),
              );
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }
}

class FavButton extends ConsumerWidget {
  const FavButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Container(
        height: 50,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        child: ref.watch(detailLogicProvider).isFavorite
            ? const Icon(Icons.favorite, size: 25, color: Colors.white)
            : const Icon(Icons.favorite_border, size: 25, color: Colors.white),
      ),
      onPressed: () {
        ref.read(detailLogicProvider.notifier).setFavorite();
      },
    );
  }
}
