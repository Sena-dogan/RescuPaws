import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../config/router/app_router.dart';
import '../../../data/enums/detail_enums.dart';
import '../../../models/paw_entry.dart';
import '../../../utils/context_extensions.dart';
import '../../widgets/adaptive_image.dart';
import 'swipe_card_logic.dart';
import 'widgets/image_line_indicator.dart';

class SwipeCard extends ConsumerWidget {
  const SwipeCard({
    super.key,
    required this.pawEntry,
    this.size = const Size(308, 426.76),
  });

  final PawEntry pawEntry;
  final Size size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int id = ref.watch(swipeCardLogicProvider).id;
    // image length is 3
    // selectedImageIndex is 2
    // when i tap right, i want to go to the next image
    // setTap function will increase the selectedImageIndex by 1
    // so it will be 3 and it will be out of bound
    // but if you do selectedImageIndex % images.length
    // it will be 3 % 3 = 0
    int selectedImageIndex =
        ref.watch(swipeCardLogicProvider).selectedImageIndex < 0
            ? pawEntry.image!.length - 1
            : ref.watch(swipeCardLogicProvider).selectedImageIndex %
                pawEntry.image!.length;
    if (id != pawEntry.id) {
      selectedImageIndex = 0;
    }
    final List<String> images = pawEntry.image!;
    final String image = selectedImageIndex < images.length
        ? images[selectedImageIndex]
        : '';
    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        // debugPrint(
        //     'tHello i am Gustova fring number ${pawEntry.id}. Today i will serve your chicken. Killer chicken :))))))))))))))))))))}');
        // Only respond to tap events if this card is the selected card
        // left right and middle
        if (details.globalPosition.dx < context.width / 3) {
          debugPrint('tapped left');
          ref.read(swipeCardLogicProvider.notifier).setTap(Direction.Left);
        } else if (details.globalPosition.dx > context.width / 3 * 2) {
          debugPrint('tapped right');
          ref.read(swipeCardLogicProvider.notifier).setTap(Direction.Right);
        } else {
          context.push(SGRoute.detail.route, extra: pawEntry.id);
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
              child: AdaptiveImage(
                imageUrl: image,
                errorWidget: (BuildContext context, String error, Object obj) {
                  debugPrint(
                      'Error occured while loading image: ${pawEntry.image?.firstOrNull} \n');
                  debugPrint('Id of the paw entry: ${pawEntry.id}');
                  // FirebaseCrashlytics.instance.recordError(
                  //   error,
                  //   stackTrace,
                  //   reason:
                  //       '[API] Error occured while loading image. Id of the paw entry: ${pawEntry.id}',
                  //   printDetails: true,
                  // );
                  return const Icon(Icons.broken_image);
                },
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Gap(10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(
                          Icons.location_on_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        const Gap(5),
                        Flexible(
                          child: Text(
                            maxLines: 1,
                            pawEntry.address ?? '',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              child: Container(
            height: size.height * 0.1,
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(27),
                  topRight: Radius.circular(27),
                ),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromARGB(205, 68, 49, 28),
                  Colors.transparent,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ImageLineIndicator(
                numberOfImages: pawEntry.images_uploads?.length == 1
                    ? 0
                    : pawEntry.images_uploads?.length ?? 0,
                selectedIndex: selectedImageIndex,
              ),
            ),
          ))
        ],
      ),
    );
  }
}
