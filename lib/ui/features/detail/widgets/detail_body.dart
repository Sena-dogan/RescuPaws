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

class DetailBody extends StatelessWidget {
  const DetailBody({
    super.key,
    required this.ref,
    required bool pinned,
    required this.pawEntryDetail,
    required this.size,
  }) : _pinned = pinned;

  final WidgetRef ref;
  final bool _pinned;
  final PawEntryDetail? pawEntryDetail;
  final Size size;

  @override
  Widget build(BuildContext context) {
    //final DetailUiModel detailUiModel;
    if (pawEntryDetail == null) {
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
                ref
                    .read(detailLogicProvider.notifier)
                    .shareContent(pawEntryDetail?.name ?? '');
              },
            ),
            FavButton(ref: ref),
          ],
          expandedHeight: MediaQuery.of(context).size.height * 0.5,
          flexibleSpace:
              PawImageandName(pawEntryDetail: pawEntryDetail, ref: ref),
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
                      pawEntryDetail?.description ?? '',
                      style: context.textTheme.labelSmall,
                    ),
                    const Gap(10),
                    Text(
                      pawEntryDetail?.address ?? '',
                      style: context.textTheme.bodyMedium,
                    ),
                    const Gap(30),
                    Characteristics(
                      pawEntryDetail: pawEntryDetail,
                    ),
                    const Gap(30),
                    Text(
                      pawEntryDetail?.createdAtFormatted ?? '',
                      style: context.textTheme.bodyMedium,
                    ),
                    const Gap(30),
                    AdvertiserInfo(
                      pawEntryDetail: pawEntryDetail,
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

class FavButton extends StatelessWidget {
  const FavButton({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
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

class PawImageandName extends StatelessWidget {
  const PawImageandName({
    super.key,
    required this.pawEntryDetail,
    required this.ref,
  });

  final PawEntryDetail? pawEntryDetail;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: context.colorScheme.background.withOpacity(0.4),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        child: Text(pawEntryDetail?.name ?? '',
            style: context.textTheme.labelMedium),
      ),
      background: GestureDetector(
        onDoubleTap: () {
          ref.read(detailLogicProvider.notifier).setFavorite();
        },
        child: Image.network(
          pawEntryDetail?.images_uploads?.firstOrNull?.image_url ?? '',
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            debugPrint(
                'Error occured while loading image: ${pawEntryDetail?.images_uploads?.firstOrNull?.image_url} \n');
            debugPrint('Id of the paw entry: ${pawEntryDetail?.id}');
            return Image.network(
                'https://i.pinimg.com/736x/fc/05/5f/fc055f6e40faed757050d459b66e88b0.jpg');
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
