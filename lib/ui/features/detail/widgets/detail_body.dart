import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_router.dart';
import '../../../../models/images_upload.dart';
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
    required this.pawEntryDetailResponse,
    required this.size,
  }) : _pinned = pinned;

  final WidgetRef ref;
  final bool _pinned;
  final GetPawEntryDetailResponse? pawEntryDetailResponse;
  final Size size;

  @override
  Widget build(BuildContext context) {
    //final DetailUiModel detailUiModel;
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
            FavButton(ref: ref),
          ],
          expandedHeight: MediaQuery.of(context).size.height * 0.5,
          flexibleSpace: PawImageandName(
              pawEntryDetailResponse: pawEntryDetailResponse, ref: ref),
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
    required this.pawEntryDetailResponse,
    required this.ref,
  });

  final GetPawEntryDetailResponse? pawEntryDetailResponse;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
        child: Text(pawEntryDetailResponse!.pawEntryDetail?.name ?? '',
            style: context.textTheme.labelMedium),
      ),
      background: GestureDetector(
          onDoubleTap: () {
            ref.read(detailLogicProvider.notifier).setFavorite();
          },
          child: CarouselSlider(
            options: CarouselOptions(
              height: size.height * 0.6,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
            ),
            items: pawEntryDetailResponse!.pawEntryDetail?.images_uploads
                ?.map((ImagesUploads item) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.zero,
                    child: Image.network(
                      item.image_url ?? '',
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        debugPrint(
                            'Error occured while loading image: ${item.image_url} \n');
                        debugPrint(
                            'Id of the paw entry: ${pawEntryDetailResponse!.pawEntryDetail?.id}');
                        return Image.network(
                            'https://i.pinimg.com/736x/fc/05/5f/fc055f6e40faed757050d459b66e88b0.jpg');
                      },
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            }).toList(),
          )),
    );
  }
}
