import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../config/router/app_router.dart';
import '../../constants/icons.dart';
import '../../states/widgets/bottom_nav_bar/nav_bar_logic.dart';
import '../../utils/context_extensions.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: prefer_final_locals, always_specify_types
    var nav = ref.watch(bottomNavBarLogicProvider);

    return AnimatedBottomNavigationBar.builder(
        itemCount: 2,
        tabBuilder: (int index, bool isActive) {
          return index == 0
              ? Column(
                  children: <Widget>[
                    SvgPicture.asset(
                      AppIcons.home,
                      color: isActive
                          ? context.colorScheme.primary
                          : context.colorScheme.tertiary,
                      height: 40,
                    ),
                    Text(
                      'Ana Sayfa',
                      style: TextStyle(
                        color: isActive
                            ? context.colorScheme.primary
                            : context.colorScheme.tertiary,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: <Widget>[
                    SvgPicture.asset(
                      AppIcons.profile,
                      color: isActive
                          ? context.colorScheme.primary
                          : context.colorScheme.tertiary,
                      height: 40,
                    ),
                    Text(
                      'Profil',
                      style: TextStyle(
                        color: isActive
                            ? context.colorScheme.primary
                            : context.colorScheme.tertiary,
                      ),
                    ),
                  ],
                );
        },
        activeIndex: nav.navIndex,
        onTap: (int index) {
          ref.read(bottomNavBarLogicProvider.notifier).setNavIndex(index);
          debugPrint('Current Index is $index');
          debugPrint('Current Route is ${SGRoute.values[index].route}');
          context.go(SGRoute.values[index].route);
        },
        gapLocation: GapLocation.none,
        //borderColor: Colors.grey.withOpacity(0.5),
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 20,
        rightCornerRadius: 20,
        splashColor: context.colorScheme.primary,
        height: 70,
        backgroundColor: context.colorScheme.tertiaryContainer,
        shadow: Shadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 10,
        ));
  }
}
