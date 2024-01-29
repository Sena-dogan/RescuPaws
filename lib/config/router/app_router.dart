// ignore_for_file: prefer_function_declarations_over_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';

import '../../constants/assets.dart';
import '../../data/getstore/get_store_helper.dart';
import '../../di/components/service_locator.dart';
import '../../ui/features/auth/email_login_screen.dart';
import '../../ui/features/auth/login_screen.dart';
import '../../ui/features/detail/detail_page.dart';
import '../../ui/features/intro/intro_screen.dart';
import '../../ui/features/new_paw/screens/address_input_screen.dart';
import '../../ui/features/new_paw/screens/information_screen.dart';
import '../../ui/features/new_paw/screens/new_paw_image_screen.dart';
import '../../ui/features/new_paw/screens/new_paw_screen.dart';
import '../../ui/features/new_paw/screens/select_breed_screen.dart';
import '../../ui/features/new_paw/screens/select_subBreed_screen.dart';
import '../../ui/features/new_paw/screens/weight_screen.dart';
import '../../ui/features/profile/user_screen.dart';
import '../../ui/home/home.dart';
import 'fade_extension.dart';

GetStoreHelper getStoreHelper = getIt<GetStoreHelper>();

enum SGRoute {
  home,
  profile,
  newpaw,
  breed,
  subbreed,
  information,
  address,
  pawimage,
  intro,
  firstScreen,
  emailLogin,
  login,
  register,
  forgotPassword,
  editProfile,
  changePassword,
  weight,
  detail;

  String get route => '/${toString().replaceAll('SGRoute.', '')}';
  String get name => toString().replaceAll('SGRoute.', '');
}

@Singleton()
class SGGoRouter {
  final GoRouter goRoute = GoRouter(
    initialLocation: SGRoute.intro.route,
    errorBuilder: (BuildContext context, GoRouterState state) => Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Lottie.asset(
          Assets.NotFound,
          repeat: true,
          height: 300,
        ),
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
        path: SGRoute.emailLogin.route,
        builder: (BuildContext context, GoRouterState state) =>
            const EmailLoginScreen(),
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
        redirect: _authGuard,
      ).fade(),
      GoRoute(
        path: SGRoute.detail.route,
        builder: (BuildContext context, GoRouterState state) => DetailScreen(
          id: state.extra! as int,
        ),
        redirect: _authGuard,
      ).fade(),
      GoRoute(
        path: SGRoute.breed.route,
        builder: (BuildContext context, GoRouterState state) =>
            const SelectBreedScreen(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: SGRoute.subbreed.route,
        builder: (BuildContext context, GoRouterState state) =>
            const SelectSubBreedWidget(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: SGRoute.information.route,
        builder: (BuildContext context, GoRouterState state) =>
            const NewPawInformationScreen(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: SGRoute.weight.route,
        builder: (BuildContext context, GoRouterState state) =>
            const WeightScreen(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: SGRoute.address.route,
        builder: (BuildContext context, GoRouterState state) =>
            const AddressInputScreen(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: SGRoute.pawimage.route,
        builder: (BuildContext context, GoRouterState state) =>
            const NewPawImageScreen(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: SGRoute.newpaw.route,
        builder: (BuildContext context, GoRouterState state) =>
            const NewPawScreen(),
        redirect: _authGuard,
      ).fade(),
    ],
  );
  GoRouter get getGoRouter => goRoute;
}

// ignore: unused_element
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
  FirebaseAuth.instance.currentUser!.reload().catchError((Object error) {
    return Future<void>.error(SGRoute.login.route);
  });
  return null;
};
