// ignore_for_file: prefer_function_declarations_over_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../data/getstore/get_store_helper.dart';
import '../../di/components/service_locator.dart';
import '../../ui/features/auth/login_screen.dart';
import '../../ui/features/intro/intro_screen.dart';
import '../../ui/features/profile/user_screen.dart';
import '../../ui/home/home.dart';
import 'fade_extension.dart';

GetStoreHelper getStoreHelper = getIt<GetStoreHelper>();

enum SGRoute {
  home,
  profile,
  intro,
  firstScreen,
  login,
  register,
  forgotPassword,
  editProfile,
  changePassword;

  String get route => '/${toString().replaceAll('SGRoute.', '')}';
  String get name => toString().replaceAll('SGRoute.', '');
}

@Singleton()
class SGGoRouter {
  final GoRouter goRoute = GoRouter(
    initialLocation: SGRoute.intro.route,
    errorBuilder: (BuildContext context, GoRouterState state) =>
        Scaffold(body: Column(
          children: [
            Center(child: Text('Page not found: ${state.path}')),
            ElevatedButton(
              onPressed: () => context.go(SGRoute.home.route),
              child: const Text('Go Back'),
            ),
          ],
        )),
    routes: <GoRoute>[
      GoRoute(
        path: SGRoute.home.route,
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
        redirect: _authGuard,
      ).fade(),
      GoRoute(
        path: SGRoute.intro.route,
        builder: (BuildContext context, GoRouterState state) =>
            const IntroScreen(),
      ).fade(),
      GoRoute(
        path: SGRoute.login.route,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ).fade(),
      GoRoute(
        path: SGRoute.profile.route,
        builder: (BuildContext context, GoRouterState state) =>
            const ProfileScreen(),
      ).fade(),
    ],
  );
  GoRouter get getGoRouter => goRoute;
}

final String? Function(BuildContext context, GoRouterState state) _introGuard =
    (BuildContext context, GoRouterState state) {
  if (!(getStoreHelper.getIntro() == null ||
      getStoreHelper.getIntro()! == true)) {
    return SGRoute.intro.route;
  }
  return null;
};

/// Example: Auth guard for Route Protection. GetStoreHelper is used to get token.
// ignore: unused_element
final String? Function(BuildContext context, GoRouterState state) _authGuard =
    (BuildContext context, GoRouterState state) {
  if (FirebaseAuth.instance.currentUser == null) {
    return SGRoute.login.route;
  }
  return null;
};
