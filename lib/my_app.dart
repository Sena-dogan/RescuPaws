import 'package:easy_localization/easy_localization.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/router/app_router.dart';
import 'config/theme/theme_logic.dart';
import 'config/theme/theme_ui_model.dart';
import 'utils/pati_color_scheme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeUiModel currentTheme = ref.watch(themeLogicProvider);
    final GoRouter goRouter = ref.watch(goRouteProvider);
    return MaterialApp.router(
      routerConfig: goRouter,

      /// Localization is not available for the title.
      title: 'Pati Pati App',

      // Theme config for FlexColorScheme version 7.2.x. Make sure you use
      // same or higher package version, but still same major version. If you
      // use a lower package version, some properties may not be supported.
      // In that case remove them after copying this theme to your app.
      theme: FlexThemeData.light(
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 13,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 10,
            blendOnColors: false,
            useTextTheme: true,
            useM2StyleDividerInM3: true,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          textTheme: textTheme,
          colorScheme: lightColorScheme(),
          fontFamily: GoogleFonts.poppins().fontFamily

          // To use the Playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
          ),
      darkTheme: FlexThemeData.dark(
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 13,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 20,
            useTextTheme: true,
            useM2StyleDividerInM3: true,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          textTheme: textTheme,
          colorScheme: darkColorScheme(),
          fontFamily: GoogleFonts.poppins().fontFamily
          // To use the Playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
          ),
      themeMode: currentTheme.themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
    );
  }
}

final TextTheme textTheme = TextTheme(
  displayLarge: GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: 45,
  ),
  displayMedium: GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: 40,
  ),
  displaySmall: GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: 35,
  ),
  labelLarge: GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: 30,
  ),
  labelMedium: GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 25,
  ),
  labelSmall: GoogleFonts.poppins(
    fontWeight: FontWeight.w500,
    fontSize: 20,
  ),
  bodyLarge: GoogleFonts.poppins(
    fontWeight: FontWeight.w500,
    fontSize: 15,
  ),
  bodyMedium: GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 13,
  ),
  bodySmall: GoogleFonts.poppins(
    fontWeight: FontWeight.w300,
    fontSize: 11,
  ),

  /// chat bubble text
  titleSmall: GoogleFonts.poppins(
    fontWeight: FontWeight.w300,
    fontSize: 14,
  ),
);

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
}
