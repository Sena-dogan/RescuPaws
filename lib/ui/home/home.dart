import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ionicons/ionicons.dart';

import '../../../utils/context_extensions.dart';

import '../../constants/assets.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late CardSwiperController controller;
  List<String> images = <String>[
    'https://i.pinimg.com/736x/fc/05/5f/fc055f6e40faed757050d459b66e88b0.jpg',
    'https://i.pinimg.com/originals/4b/51/6b/4b516bde0096f8d125fc9f43df04d791.jpg'
  ];

  @override
  void initState() {
    super.initState();
    controller = CardSwiperController();
  }

  @override
  Widget build(BuildContext context) {
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
        floatingActionButton: SizedBox(
          width: 75,
          height: 75,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {},
              clipBehavior: Clip.antiAlias,
              // Shape of 4 edged circle rotated 45 degrees
              shape: const StarBorder.polygon(
                sides: 4,
                rotation: 90,
                pointRounding: 0.7,
              ),
              child: Image.asset(
                height: 32,
                width: 32,
                Assets.paw,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const BottomNavBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: SizedBox(
                width: 308,
                height: 426.76,
                child: CardSwiper(
                    cardsCount: images.length,
                    duration: const Duration(milliseconds: 300),
                    controller: controller,
                    onSwipe: (int oldIndex, int? newIndex,
                        CardSwiperDirection direction) {
                      return true;
                    },
                    allowedSwipeDirection:
                        AllowedSwipeDirection.only(right: true, left: true),
                    cardBuilder: (BuildContext context, int index,
                        int percentThresholdX, int percentThresholdY) {
                      return SwipeCard(image: images[index]);
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            width: 42,
            height: 42,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image:
                    NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
                fit: BoxFit.fill,
              ),
              shape: const OvalBorder(),
            ),
          ),
        )
      ],
    );
  }
}

class RightButton extends StatelessWidget {
  const RightButton({
    super.key,
    required this.controller,
  });

  final CardSwiperController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: 100,
      decoration: ShapeDecoration(
        color: context.colorScheme.primary,
        shadows: const <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            offset: Offset(0, 3),
            blurRadius: 6,
          )
        ],
        shape: StarBorder.polygon(
          side: BorderSide(
            color: Colors.black.withOpacity(0.17000000178813934),
          ),
          pointRounding: 0.3,
          sides: 3,
          // left rotation
          rotation: 90,
        ),
      ),
      child: InkWell(
        onTap: () {
          debugPrint('Tapped right');
          controller.swipeRight();
        },
        customBorder: StarBorder.polygon(
          side: BorderSide(
            color: Colors.black.withOpacity(0.17000000178813934),
          ),
          pointRounding: 0.3,
          sides: 3,
          // left rotation
          rotation: 90,
        ),
        splashFactory: NoSplash.splashFactory,
        child: const Icon(
          // Paw icon
          Ionicons.heart_outline,
          size: 25,
          color: Colors.white,
        ),
      ),
    );
  }
}

class LeftButton extends StatelessWidget {
  const LeftButton({
    super.key,
    required this.controller,
  });

  final CardSwiperController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: 100,
      decoration: ShapeDecoration(
        shadows: const <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            offset: Offset(0, 3),
            blurRadius: 6,
          )
        ],
        color: Colors.white,
        shape: StarBorder.polygon(
          side: BorderSide(
            color: Colors.black.withOpacity(0.17000000178813934),
          ),
          pointRounding: 0.3,
          sides: 3,
          // left rotation
          rotation: 270,
        ),
      ),
      child: InkWell(
        onTap: () {
          debugPrint('Tapped left');
          controller.swipeLeft();
          controller.swipeLeft();
        },
        customBorder: StarBorder.polygon(
          side: BorderSide(
            color: Colors.black.withOpacity(0.17000000178813934),
          ),
          pointRounding: 0.3,
          sides: 3,
          // left rotation
          rotation: 270,
        ),
        splashFactory: NoSplash.splashFactory,
        child: Icon(
          // X icon
          Icons.close,
          size: 25,
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}

class SwipeCard extends StatelessWidget {
  const SwipeCard({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Add black overlay at the bottom

        Container(
          width: 308,
          height: 426.76,
          decoration: ShapeDecoration(
            shadows: const <BoxShadow>[
              BoxShadow(
                color: Colors.black54,
                offset: Offset(0, 3),
                blurRadius: 6,
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
              image,
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
                  Color(0x00000000),
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
                    'Name',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Text(
                      'Breed',
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
                        'Location',
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
