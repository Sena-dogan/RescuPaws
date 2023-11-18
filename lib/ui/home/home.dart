import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';

import '../../../utils/context_extensions.dart';

import '../../constants/assets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late CardSwiperController controller;
  List images = <String>[
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
        appBar: AppBar(
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
                    image: NetworkImage(
                        FirebaseAuth.instance.currentUser!.photoURL!),
                    fit: BoxFit.fill,
                  ),
                  shape: const OvalBorder(),
                ),
              ),
            )
          ],
        ),
        backgroundColor: context.colorScheme.background,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: SizedBox(
                width: 308,
                height: 426.76,
                child: CardSwiper(
                    cardsCount: images.length,
                    numberOfCardsDisplayed: 1,
                    controller: controller,
                    onSwipe: (int oldIndex, int? newIndex,
                        CardSwiperDirection direction) {
                      debugPrint('Old index: $oldIndex');
                      debugPrint('New index: $newIndex');
                      debugPrint('Direction: $direction');
                      return true;
                    },
                    allowedSwipeDirection:
                        AllowedSwipeDirection.only(right: true, left: true),
                    cardBuilder: (BuildContext context, int index,
                        int percentThresholdX, int percentThresholdY) {
                      return Container(
                        width: 308,
                        height: 426.76,
                        decoration: ShapeDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment(0.00, -1.00),
                            end: Alignment(0, 1),
                            colors: <Color>[
                              Color(0xC144311C),
                              Color(0x00C4C4C4)
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(width: 3, color: Colors.white),
                            borderRadius: BorderRadius.circular(27),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(27),
                          child: Image.network(
                            images[index] as String,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
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
                ),
                Container(
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
                )
              ],
            )
          ],
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

class CustomSplash extends StatefulWidget {
  const CustomSplash({super.key});

  @override
  _CustomSplashState createState() => _CustomSplashState();
}

class _CustomSplashState extends State<CustomSplash> {
  Offset _tapPosition = const Offset(0, 0);
  double _radius = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          _tapPosition = details.globalPosition;
        });
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          _radius = 100;
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            _radius = 0;
          });
        });
      },
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: 161.77,
              height: 105.50,
              decoration: ShapeDecoration(
                color: const Color(0xFFFCFEFF),
                shape: StarBorder.polygon(
                  side: BorderSide(
                    color: Colors.black.withOpacity(0.17000000178813934),
                  ),
                  sides: 3,
                  // left rotation
                  rotation: 270,
                ),
              ),
              child: const Icon(
                Icons.star,
                size: 50,
                color: Colors.black,
              ),
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _radius,
              height: _radius,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
