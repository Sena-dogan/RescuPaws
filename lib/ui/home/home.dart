// ignore_for_file: always_specify_types, unused_local_variable

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/context_extensions.dart';
import '../../config/router/app_router.dart';
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
  late final CardSwiperController controller;
  int messageCount = 0;

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      messageCount++;
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      messageCount++;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = CardSwiperController();
    setupInteractedMessage();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<GetPawEntryResponse> pawEntryLogic =
        ref.watch(fetchPawEntriesProvider);

    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
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
        bottomNavigationBar: const PawBottomNavBar(),
        body: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: () async => ref.refresh(fetchPawEntriesProvider.future),
            child: switch (pawEntryLogic) {
              AsyncValue<GetPawEntryResponse>(
                :final GetPawEntryResponse valueOrNull?
              ) =>
                SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics(),
                    ),
                    child: _buildBody(context, valueOrNull.data)),
              // An error is available, so we render it.
              AsyncValue(:final Object error?) => PawErrorWidget(
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

  Widget _buildBody(BuildContext context, List<PawEntry> pawEntries) {
    return pawEntries.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.7,
                  width: MediaQuery.sizeOf(context).width,
                  child: const Center(child: Text('Henüz ilan yok'))),
            ],
          )
        : Column(
            children: <Widget>[
              Divider(
                color: context.colorScheme.tertiary.withOpacity(0.15),
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.85,
                  height: MediaQuery.sizeOf(context).height * 0.55,
                  child: CardSwiper(
                      cardsCount: pawEntries.length,
                      numberOfCardsDisplayed: pawEntries.length > 1 ? 2 : 1,
                      duration: const Duration(milliseconds: 300),
                      controller: controller,
                      onSwipe: (int oldIndex, int? newIndex,
                          CardSwiperDirection direction) async {
                        //TODO: Handle swipe in the logic
                        if (newIndex != null) {
                          ref
                              .read(swipeCardLogicProvider.notifier)
                              .setId(pawEntries[newIndex].id);
                          ref
                              .read(homeScreenLogicProvider.notifier)
                              .setFavorite(pawEntries[newIndex].id,
                                  direction == CardSwiperDirection.right);
                        }
                        return true;
                      },
                      allowedSwipeDirection: const AllowedSwipeDirection.only(
                          right: true, left: true),
                      cardBuilder: (BuildContext context, int index,
                          int percentThresholdX, int percentThresholdY) {
                        return SwipeCard(
                            pawEntry: pawEntries[index],
                            size: Size(MediaQuery.sizeOf(context).width * 0.85,
                                MediaQuery.sizeOf(context).height * 0.55));
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
            onPressed: () {
              context.push(SGRoute.noNotif.route);
            },
            icon: Icon(
              Icons.notifications_none_rounded,
              size: 30,
              color: context.colorScheme.scrim.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
}
