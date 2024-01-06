import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../config/router/app_router.dart';
import '../../../models/images_upload.dart';
import '../../../models/paw_entry.dart';
import '../../../utils/context_extensions.dart';
import '../logic/home_screen_logic.dart';
import 'filter_widget.dart';

class SwipeCard extends ConsumerWidget {
  const SwipeCard({
    super.key,
    required this.pawEntry,
    required this.cardIndex,
    this.size = const Size(308, 426.76),
  });

  final PawEntry pawEntry;
  final int cardIndex;
  final Size size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int selectedCardIndex =
        ref.watch(homeScreenLogicProvider).selectedCardIndex;
    int selectedImageIndex =
        ref.watch(homeScreenLogicProvider).selectedImageIndex;
    final List<ImagesUploads>? images = pawEntry.images_uploads;
    final String? image = images != null && selectedImageIndex < images.length
        ? images[selectedImageIndex].image_url
        : '';
    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        // Only respond to tap events if this card is the selected card
        if (cardIndex == selectedCardIndex) {
          // left right and middle
          debugPrint(
              'x: ${details.globalPosition.dx} y: ${details.globalPosition.dy}');
          if (details.globalPosition.dx < context.width / 3) {
            if (selectedImageIndex > 0) {
              selectedImageIndex -= 1;
              debugPrint('tapped left');
              ref
                  .read(homeScreenLogicProvider.notifier)
                  .setTap(selectedImageIndex);
            }
          } else if (details.globalPosition.dx > context.width / 3 * 2) {
            if (selectedImageIndex < (images?.length ?? 1) - 1) {
              selectedImageIndex += 1;
              debugPrint('tapped right');
              ref
                  .read(homeScreenLogicProvider.notifier)
                  .setTap(selectedImageIndex);
            }
          } else {
            context.push(SGRoute.detail.route, extra: pawEntry.id);
          }
        }
      },
      child: Stack(
        children: <Widget>[
          // Add black overlay at the bottom
          Container(
            width: size.width,
            height: size.height,
            decoration: ShapeDecoration(
              shadows: const <BoxShadow>[
                BoxShadow(
                  color: Color.fromARGB(168, 0, 0, 0),
                  offset: Offset(0, 10),
                  blurRadius: 10,
                )
              ],
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xC144311C), Color(0x00C4C4C4)],
              ),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 3, color: Colors.white),
                borderRadius: BorderRadius.circular(27),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(27),
              child: CachedNetworkImage(
                imageUrl: image ?? '',
                errorWidget:
                    (BuildContext context, String error, Object obj) {
                  debugPrint(
                      'Error occured while loading image: ${pawEntry.images_uploads?.firstOrNull?.image_url} \n');
                  debugPrint('Id of the paw entry: ${pawEntry.id}');
                  // FirebaseCrashlytics.instance.recordError(
                  //   error,
                  //   stackTrace,
                  //   reason:
                  //       '[API] Error occured while loading image. Id of the paw entry: ${pawEntry.id}',
                  //   printDetails: true,
                  // );
                  return Image.network(
                      'https://i.pinimg.com/736x/fc/05/5f/fc055f6e40faed757050d459b66e88b0.jpg');
                },
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27),
                ),
                gradient: const LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color.fromARGB(26, 0, 0, 0),
                    Color.fromARGB(205, 68, 49, 28)
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      pawEntry.name ?? '',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        pawEntry.description ?? '',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Gap(5),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(
                          Icons.location_on_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        const Gap(5),
                        Text(
                          pawEntry.address ?? '',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    // Tags row with color with opacity is 0.5 have border radius 12 with 4px padding and primary color
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FilterWidget(),
                        Gap(5),
                        FilterWidget(),
                        Gap(5),
                        FilterWidget(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
