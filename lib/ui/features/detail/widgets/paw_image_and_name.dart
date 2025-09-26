import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rescupaws/models/paw_entry_detail.dart';
import 'package:rescupaws/ui/features/detail/logic/detail_logic.dart';
import 'package:rescupaws/ui/widgets/adaptive_image.dart';
import 'package:rescupaws/utils/context_extensions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PawImageandName extends ConsumerStatefulWidget {
  const PawImageandName({
    super.key,
    required this.pawEntryDetailResponse,
  });

  final GetPawEntryDetailResponse? pawEntryDetailResponse;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PawImageandNameState();
}

class _PawImageandNameState extends ConsumerState<PawImageandName> {
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            color: context.colorScheme.surface.withValues(alpha:0.4),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: FractionalOffset.centerLeft,
          child: Text(widget.pawEntryDetailResponse!.pawEntryDetail?.name ?? '',
              maxLines: 1, style: context.textTheme.labelSmall),
        ),
      ),
      background: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          GestureDetector(
            onDoubleTap: () {
              ref.read(detailLogicProvider.notifier).setFavorite();
            },
            child: PageView.builder(
              controller: controller,
              itemCount: widget.pawEntryDetailResponse?.pawEntryDetail!
                  .image?.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: MediaQuery.sizeOf(context).width,
                  margin: EdgeInsets.zero,
                  child: AdaptiveImage(
                    imageUrl: widget.pawEntryDetailResponse?.pawEntryDetail!
                            .image?[index] ?? '',
                    errorWidget: (BuildContext context, String url, Object error) {
                      debugPrint(
                          'Error occured while loading image: ${widget.pawEntryDetailResponse?.pawEntryDetail!.image?[index]} \n');
                      debugPrint(
                          'Id of the paw entry: ${widget.pawEntryDetailResponse?.pawEntryDetail?.id}');
                      return const Icon(Icons.broken_image);
                    },
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: size.height * 0.09,
            child: (widget.pawEntryDetailResponse?.pawEntryDetail?.image
                        ?.length ?? 0) >
                    1
                ? SmoothPageIndicator(
                    controller: controller,
                    count: widget.pawEntryDetailResponse?.pawEntryDetail!
                            .image?.length ??
                        0,
                    effect: JumpingDotEffect(
                      jumpScale: .7,
                      verticalOffset: 15,
                      activeDotColor: context.colorScheme.primary,
                    ),
                    onDotClicked: (int index) {
                      controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
