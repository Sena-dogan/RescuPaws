// ignore_for_file: always_specify_types, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/context_extensions.dart';
import '../../constants/assets.dart';
import '../../models/paw_entry.dart';
import '../../utils/error_widgett.dart';
import '../widgets/add_nav_button.dart';
import '../widgets/bottom_nav_bar.dart';
import 'logic/home_screen_logic.dart';
import 'swipe_card/swipe_card.dart';
import 'swipe_card/swipe_card_logic.dart';
import 'widgets/left_button.dart';
import 'widgets/loading_paw_widget.dart';
import 'widgets/right_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late CardSwiperController controller;

  @override
  void initState() {
    super.initState();
    controller = CardSwiperController();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<GetPawEntryResponse> pawEntryLogic =
        ref.watch(fetchPawEntriesProvider);

    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        image: const DecorationImage(
          image: AssetImage(Assets.HomeBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: _buildAppBar(),
        floatingActionButton: const AddNavButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const BottomNavBar(),
        body: RefreshIndicator(
            onRefresh: () async => ref.refresh(fetchPawEntriesProvider.future),
            child: switch (pawEntryLogic) {
              AsyncValue<GetPawEntryResponse>(
                :final GetPawEntryResponse valueOrNull?
              ) =>
                SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: _buildBody(context, valueOrNull.data)),
              // An error is available, so we render it.
              AsyncValue(:final Object error?) => ErrorWidgett(
                  error: error,
                  onRefresh: () async =>
                      ref.refresh(fetchPawEntriesProvider.future),
                ),
              // No data/error, so we're in loading state.
              _ => const Center(
                  child: LoadingPawWidget(),
                )
            }),
      ),
    );
  }

  Column _buildBody(BuildContext context, List<PawEntry> pawEntries) {
    return Column(
      children: <Widget>[
        Divider(
          color: context.colorScheme.tertiary.withOpacity(0.15),
        ),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.55,
            child: CardSwiper(
                cardsCount: pawEntries.length,
                duration: const Duration(milliseconds: 300),
                controller: controller,
                onSwipe: (int oldIndex, int? newIndex,
                    CardSwiperDirection direction) {
                  if (newIndex != null) {
                    ref
                        .read(swipeCardLogicProvider.notifier)
                        .setId(pawEntries[newIndex].id);
                  }
                  return true;
                },
                allowedSwipeDirection:
                    AllowedSwipeDirection.only(right: true, left: true),
                cardBuilder: (BuildContext context, int index,
                    int percentThresholdX, int percentThresholdY) {
                  return SwipeCard(
                      pawEntry: pawEntries[index],
                      size: Size(MediaQuery.of(context).size.width * 0.85,
                          MediaQuery.of(context).size.height * 0.55));
                }),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                // Check if the user is trying to swipe the card
                if (details.delta.dx.abs() > details.delta.dy.abs()) {
                  // Prevent the CardSwiper from receiving the swipe gesture
                  return;
                }
              },
              child: LeftButton(controller: controller),
            ),
            GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                // Check if the user is trying to swipe the card
                if (details.delta.dx.abs() > details.delta.dy.abs()) {
                  // Prevent the CardSwiper from receiving the swipe gesture
                  return;
                }
              },
              child: RightButton(controller: controller),
            )
          ],
        )
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Image.asset(
          Assets.PatiApp,
          height: 32,
          width: 128,
        ),
      ),
      leadingWidth: 128 + 20 * 2,
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
