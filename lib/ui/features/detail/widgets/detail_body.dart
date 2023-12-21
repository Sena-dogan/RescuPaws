import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_router.dart';
import '../../../../models/paw_entry_detail.dart';
import '../../../../utils/context_extensions.dart';
import 'advertiser_info.dart';
import 'characteristics.dart';

class DetailBody extends StatelessWidget {
  const DetailBody({
    super.key,
    required bool pinned,
    required this.pawEntryDetail,
    required this.size,
  }) : _pinned = pinned;

  final bool _pinned;
  final PawEntryDetail? pawEntryDetail;
  final Size size;

  @override
  Widget build(BuildContext context) {
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
                size: 25,
                color: Colors.white,
              ),
            ),
            onPressed: () => context.go(SGRoute.home.route),
          ),
          expandedHeight: MediaQuery.of(context).size.height * 0.5,
          flexibleSpace: FlexibleSpaceBar(
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
            background: Image.network(
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
