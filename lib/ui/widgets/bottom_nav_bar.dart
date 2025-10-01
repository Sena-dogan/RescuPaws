import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescupaws/config/router/app_router.dart';
import 'package:rescupaws/config/router/current_path_provider.dart';
import 'package:rescupaws/constants/icons.dart';
import 'package:rescupaws/utils/context_extensions.dart';

class PawBottomNavBar extends HookConsumerWidget {
  const PawBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? currentPath = ref.watch(currentPathProvider);

    return AnimatedBottomNavigationBar.builder(
      itemCount: 4,
      tabBuilder: (int index, bool isActive) {
        switch (index) {
          case 0:
            return NavBarIcon(
              isActive: currentPath == SGRoute.home.route,
              text: 'Home',
              icon: AppIcons.home,
            );
          case 1:
            return NavBarIcon(
              isActive: currentPath == SGRoute.favorite.route,
              text: 'Favoriler',
              icon: AppIcons.like,
            );
          case 2:
            return NavBarIcon(
              isActive:  currentPath == SGRoute.chats.route,
              text: 'Mesajlar',
              icon: AppIcons.message,
            );
          case 3:
            return NavBarIcon(
              isActive: currentPath == SGRoute.profile.route,
              text: 'Profil',
              icon: AppIcons.profile,
            );
          default:
            return const SizedBox();
        }
      },
      activeIndex: SGRoute.values.indexWhere((SGRoute route) => route.route == currentPath),
      onTap: (int index) {
        context.go(SGRoute.values[index].route);
      },
      gapLocation: GapLocation.center,
      //borderColor: Colors.grey.withValues(alpha:0.5),
      notchSmoothness: NotchSmoothness.softEdge,
      hideAnimationCurve: Curves.easeInOut,
      leftCornerRadius: 20,
      rightCornerRadius: 20,
      splashColor: context.colorScheme.primary,
      height: 70,
      backgroundColor: context.colorScheme.surface,
      shadow: Shadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 10),
    );
  }
}

class NavBarIcon extends StatelessWidget {
  const NavBarIcon({
    super.key,
    required this.isActive,
    required this.text,
    required this.icon,
  });

  final bool isActive;
  final String text;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SvgPicture.asset(
          icon,
          colorFilter: ColorFilter.mode(
            isActive
                ? context.colorScheme.primary
                : context.colorScheme.onSurfaceVariant,
            BlendMode.srcIn,
          ),
          height: 40,
        ),
        Text(
          text,
          style: TextStyle(
            color: isActive
                ? context.colorScheme.primary
                : context.colorScheme.onSurfaceVariant,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
