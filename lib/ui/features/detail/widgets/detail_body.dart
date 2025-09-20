import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:rescupaws/models/paw_entry_detail.dart';
import 'package:rescupaws/models/user_data.dart';
import 'package:rescupaws/ui/features/chat/logic/chat_logic.dart';
import 'package:rescupaws/ui/features/chat/screens/message_screen.dart';
import 'package:rescupaws/ui/features/detail/logic/detail_logic.dart';
import 'package:rescupaws/ui/features/detail/widgets/advertiser_info.dart';
import 'package:rescupaws/ui/features/detail/widgets/characteristics.dart';
import 'package:rescupaws/ui/features/detail/widgets/paw_image_and_name.dart';
import 'package:rescupaws/utils/context_extensions.dart';

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
                color: Colors.black.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () => context.pop(),
          ),
          actions: <Widget>[
            IconButton(
              icon: Container(
                height: 50,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
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
            //TODO: Add favorite functionality to the detail page
            const FavButton(),
          ],
          expandedHeight: MediaQuery.sizeOf(context).height * 0.5,
          flexibleSpace: PawImageandName(
            pawEntryDetailResponse: pawEntryDetailResponse,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              Size size = MediaQuery.sizeOf(context);
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
          Consumer(builder:
            (BuildContext context, WidgetRef ref, Widget? child) {
                      String? advertiserId =
                          pawEntryDetailResponse!.pawEntryDetail?.user_id ??
                              pawEntryDetailResponse!.pawEntryDetail?.user?.uid;
            AsyncValue<UserData?> userAsync = ref.watch(
              getUserByIdProvider(advertiserId ?? ''));
            return userAsync.when(
                        data: (UserData? user) => AdvertiserInfo(
              receiverName: user?.displayName ?? 'Kullanıcı',
              receiverProfilePic: user?.photoUrl ?? '',
                          imageSize: size.width * 0.2,
                          textStyle: context.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      );
                    }),
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
                        onPressed: () async {
                          String receiverId =
                pawEntryDetailResponse!.pawEntryDetail?.user_id ??
                  pawEntryDetailResponse!
                                      .pawEntryDetail?.user?.uid ??
                                  '';
                          if (receiverId.isEmpty) {
                            Logger().e('Receiver id is empty');
                            throw Exception(
                                'Üye bilgileri alınamadı. Lütfen tekrar deneyin.');
                          }
              UserData? user = await ref
                .read(chatLogicProvider.notifier)
                              .getUserDataById(receiverId);
              if (user != null) {
              await ref
                .read(chatLogicProvider.notifier)
                .addReceiverUserToFirestore(
                  receiverUser: user,
                );
              }

              if (!context.mounted) return;

                          await Navigator.push(
                            context,
                            // ignore: always_specify_types
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) {
                                return MessageScreen(
                                  receiverId: receiverId,
                  receiverName:
                    user?.displayName ?? 'Kullanıcı',
                  receiverProfilePic: user?.photoUrl ?? '',
                                );
                              },
                            ),
                          );
                        },
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
          color: Colors.black.withValues(alpha: 0.4),
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
