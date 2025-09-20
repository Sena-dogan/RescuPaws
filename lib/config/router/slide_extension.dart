// ignore_for_file: strict_raw_type, always_specify_types

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rescupaws/data/enums/router_enums.dart';

class SlideTransitionPage extends CustomTransitionPage {
  SlideTransitionPage({
    required LocalKey super.key,
    required super.child,
    required this.direction,
  }) : super(
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            Offset beginOffset;
            switch (direction) {
              case SlideDirection.leftToRight:
                beginOffset = const Offset(-1, 0); // Start from the left
              case SlideDirection.rightToLeft:
                beginOffset = const Offset(1, 0); // Start from the right
            }

            return SlideTransition(
              position: Tween<Offset>(
                begin: beginOffset,
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
  final SlideDirection direction;
}

/// Extension for GoRouter to add slide transition
extension GoRouteExtension on GoRoute {
  /// Add slide transition to the route page with configurable direction
  GoRoute slide({SlideDirection direction = SlideDirection.leftToRight}) {
    return GoRoute(
      path: path,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return SlideTransitionPage(
          key: ValueKey<String>(path),
          child: builder!(context, state),
          direction: direction, // Pass the direction to the SlideTransitionPage
        );
      },
      redirect: redirect,
      
    );
  }
}
