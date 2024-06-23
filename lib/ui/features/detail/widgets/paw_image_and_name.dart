import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../models/paw_entry_detail.dart';
import '../../../../utils/context_extensions.dart';
import '../logic/detail_logic.dart';

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
    final Size size = MediaQuery.sizeOf(context);
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            color: context.colorScheme.background.withOpacity(0.4),
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
                  .images_uploads?.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: MediaQuery.sizeOf(context).width,
                  margin: EdgeInsets.zero,
                  child: Image.network(
                    widget.pawEntryDetailResponse?.pawEntryDetail!
                            .images_uploads?[index].image_url ??
                        '',
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      debugPrint(
                          'Error occured while loading image: ${widget.pawEntryDetailResponse?.pawEntryDetail!.images_uploads?[index].image_url} \n');
                      debugPrint(
                          'Id of the paw entry: ${widget.pawEntryDetailResponse?.pawEntryDetail?.id}');
                      return Image.network(
                          'https://i.pinimg.com/736x/fc/05/5f/fc055f6e40faed757050d459b66e88b0.jpg');
                    },
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: size.height * 0.09,
            child: widget.pawEntryDetailResponse?.pawEntryDetail!.images_uploads
                        ?.length !=
                    1
                ? SmoothPageIndicator(
                    controller: controller,
                    count: widget.pawEntryDetailResponse?.pawEntryDetail!
                            .images_uploads?.length ??
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
