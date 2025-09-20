import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:rescupaws/config/router/slide_extension.dart';
import 'package:rescupaws/constants/assets.dart';
import 'package:rescupaws/data/enums/router_enums.dart';
import 'package:rescupaws/ui/features/auth/presentation/login_screen.dart';
import 'package:rescupaws/ui/features/auth/presentation/number_input_screen.dart';
import 'package:rescupaws/ui/features/auth/presentation/otp_screen.dart';
import 'package:rescupaws/ui/features/auth/presentation/register_screen.dart';
import 'package:rescupaws/ui/features/category/presentation/select_breed_screen.dart';
import 'package:rescupaws/ui/features/category/presentation/select_sub_breed_screen.dart';
import 'package:rescupaws/ui/features/chat/screens/chats_screen.dart';
import 'package:rescupaws/ui/features/detail/detail_page.dart';
import 'package:rescupaws/ui/features/detail/vaccine_page.dart';
import 'package:rescupaws/ui/features/entries/my_entries_screen.dart';
import 'package:rescupaws/ui/features/favorite/favorite_screen.dart';
import 'package:rescupaws/ui/features/intro/intro_screen.dart';
import 'package:rescupaws/ui/features/new_paw/screens/address_input_screen.dart';
import 'package:rescupaws/ui/features/new_paw/screens/information_screen.dart';
import 'package:rescupaws/ui/features/new_paw/screens/new_paw_image_screen.dart';
import 'package:rescupaws/ui/features/new_paw/screens/new_paw_screen.dart';
import 'package:rescupaws/ui/features/new_paw/screens/vaccine_new_paw.dart';
import 'package:rescupaws/ui/features/new_paw/screens/weight_screen.dart';
import 'package:rescupaws/ui/features/notification/no_notif_screen.dart';
import 'package:rescupaws/ui/features/profile/user_screen.dart';
import 'package:rescupaws/ui/home/home.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

enum SGRoute {
  home,
  favorite,
  chats,
  profile,
  noNotif,
  intro,
  breed,
  subbreed,
  information,
  address,
  pawimage,
  firstScreen,
  emailLogin,
  newpaw,
  login,
  register,
  forgotPassword,
  editProfile,
  changePassword,
  weight,
  vaccine,
  vaccineNewPaw,
  phone,
  detail,
  otp, myEntries;

  String get route => '/${toString().replaceAll('SGRoute.', '')}';
  String get name => toString().replaceAll('SGRoute.', '');
}

@riverpod
GoRouter goRoute(Ref ref) {
  return GoRouter(
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
        Center(child: Text('Sayfa Bulunamadı: ${state.path}')),
        ElevatedButton(
          onPressed: () => context.go(SGRoute.home.route),
          child: const Text('Geri Dön'),
        ),
      ],
    )),
    routes: <GoRoute>[
      GoRoute(
        path: SGRoute.home.route,
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
        // redirect: _authGuard,
      ).slide(),
      GoRoute(
        path: SGRoute.intro.route,
        builder: (BuildContext context, GoRouterState state) =>
            const IntroScreen(),
      ),
      GoRoute(
        path: SGRoute.login.route,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ),
      GoRoute(
        path: SGRoute.register.route,
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterScreen(),
      ),
      GoRoute(
        path: SGRoute.profile.route,
        builder: (BuildContext context, GoRouterState state) =>
            const ProfileScreen(),
        redirect: _authGuard,
      ).slide(
        direction: SlideDirection.rightToLeft,
      ),
      GoRoute(
        path: SGRoute.detail.route,
        builder: (BuildContext context, GoRouterState state) => DetailScreen(
          id: state.extra! as int,
        ),
        redirect: _authGuard,
      ),
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
      ),
      GoRoute(
        path: SGRoute.noNotif.route,
        builder: (BuildContext context, GoRouterState state) =>
            const NoNotifScreen(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: SGRoute.vaccine.route,
        builder: (BuildContext context, GoRouterState state) => VaccineScreen(
          id: state.extra! as int,
        ),
        redirect: _authGuard,
      ),
      GoRoute(
        path: SGRoute.vaccineNewPaw.route,
        builder: (BuildContext context, GoRouterState state) =>
            const VaccinesNewPaw(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: SGRoute.favorite.route,
        builder: (BuildContext context, GoRouterState state) =>
            const FavoritesScreen(),
        redirect: _authGuard,
      ),
      GoRoute(
          path: SGRoute.phone.route,
          builder: (BuildContext context, GoRouterState state) =>
              const NumberInputScreen(),
          redirect: _authGuard),
      GoRoute(
        path: SGRoute.otp.route,
        builder: (BuildContext context, GoRouterState state) =>
            const OtpScreen(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: SGRoute.chats.route,
        builder: (BuildContext context, GoRouterState state) =>
            const ChatsScreen(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: SGRoute.myEntries.route,
        builder: (BuildContext context, GoRouterState state) =>
            const MyEntriesScreen(),
        redirect: _authGuard,
      ),
    ],
  );
}

/// Example: Auth guard for Route Protection. GetStoreHelper is used to get token.
// ignore: prefer_function_declarations_over_variables
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
