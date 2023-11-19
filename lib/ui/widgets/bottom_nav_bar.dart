import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../config/router/app_router.dart';
import '../../states/widgets/bottom_nav_bar/nav_bar_logic.dart';
import '../../utils/context_extensions.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: prefer_final_locals, always_specify_types
    var nav = ref.watch(bottomNavBarLogicProvider);

    return AnimatedBottomNavigationBar(
      icons: const <IoniconsData>[
        Ionicons.home_outline,
        Ionicons.search_outline,
        Ionicons.heart_outline,
        Ionicons.person_outline,
      ],
      activeIndex: nav.navIndex,
      onTap: (int index) {
        ref.read(bottomNavBarLogicProvider.notifier).setNavIndex(index);
        context.go(SGRoute.values[index].route);
      },
      gapLocation: GapLocation.center,
      borderColor: Colors.grey.withOpacity(0.5),
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 20,
      rightCornerRadius: 20,
      splashColor: context.colorScheme.primary,
      inactiveColor: Colors.grey,
      activeColor: context.colorScheme.primary,
      elevation: 0,
      iconSize: 24,
      height: 70,
      backgroundColor: Colors.white,
    );
  }
}
