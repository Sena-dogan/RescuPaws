import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/context_extensions.dart';

import '../../config/router/app_router.dart';
import '../../constants/assets.dart';
import '../../models/paw_entry.dart';
import '../../states/widgets/bottom_nav_bar/nav_bar_logic.dart';
import '../widgets/add_nav_button.dart';
import '../widgets/bottom_nav_bar.dart';
import 'logic/home_screen_logic.dart';
import 'logic/home_screen_ui_model.dart';
import 'widgets/left_button.dart';
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
    ref
        .read(fetchPawEntriesProvider.future)
        .then((Either<String, GetPawEntryResponse> value) => <void>{
              value.fold(
                (String errorMessage) => ref
                    .read(homeScreenLogicProvider.notifier)
                    .setError(errorMessage),
                (GetPawEntryResponse pawEntryResponse) {
                  ref
                      .read(homeScreenLogicProvider.notifier)
                      .setPawEntries(pawEntryResponse.data);
                },
              )
            });
  }

  @override
  Widget build(BuildContext context) {
    final HomeScreenUiModel homeScreenUiModel =
        ref.watch(homeScreenLogicProvider);
    final List<PawEntry> pawEntries = homeScreenUiModel.pawEntries;
    if (homeScreenUiModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
        body: pawEntries.isEmpty
            ? const ErrorWidget()
            : Column(
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
                            return true;
                          },
                          allowedSwipeDirection: AllowedSwipeDirection.only(
                              right: true, left: true),
                          cardBuilder: (BuildContext context, int index,
                              int percentThresholdX, int percentThresholdY) {
                            return SwipeCard(
                            
                                pawEntry: pawEntries[index],
                           
                                size: Size(
                                    MediaQuery.of(context).size.width * 0.85,
                               
                                    MediaQuery.of(context).size.height * 0.55));
                          }),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LeftButton(controller: controller),
                      RightButton(controller: controller)
                    ],
                  )
                ],
              ),
      ),
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
        InkWell(
          onTap: () {
            context.go(SGRoute.profile.route);
            ref.read(bottomNavBarLogicProvider.notifier).setNavIndex(1);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              width: 42,
              height: 42,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: Image.network(
                    FirebaseAuth.instance.currentUser?.photoURL ??
                        'https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg',
                    errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) =>
                        Image.network(
                            'https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg'),
                  ).image,
                  fit: BoxFit.fill,
                ),
                shape: const OvalBorder(),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(
              Assets.PawPaw,
              filterQuality: FilterQuality.none,
              fit: BoxFit.none,
            ),
          ),
          const Gap(10),
          Text(
            'Bir sorun oluştu.\n',
            style: context.textTheme.bodyLarge,
          ),
        ]);
  }
}

class SwipeCard extends StatelessWidget {
  const SwipeCard({
    super.key,
    required this.pawEntry,
    this.size = const Size(308, 426.76),
  });

  final PawEntry pawEntry;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            child: Image.network(
              pawEntry.images_uploads?.firstOrNull?.image_url ?? '',
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
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
    );
  }
}

class FilterWidget extends StatelessWidget {
  const FilterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 20,
      decoration: ShapeDecoration(
        color: Colors.white.withOpacity(0.6800000071525574),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFE18525)),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class LanguageTile extends StatelessWidget {
  const LanguageTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      onChanged: (bool newValue) {
        /// Example: Change locale
        /// The initial locale is automatically determined by the library.
        /// Changing the locale like this will persist the selected locale.
        context.setLocale(newValue ? const Locale('tr') : const Locale('en'));
      },
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      value: context.locale == const Locale('tr'),
      title: Text(
        tr('toggle_language'),
        style:
            Theme.of(context).textTheme.titleMedium!.apply(fontWeightDelta: 2),
      ),
    );
  }
}
