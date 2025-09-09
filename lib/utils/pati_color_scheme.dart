// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';

ColorScheme lightColorScheme() {
  return const ColorScheme.light(
    /// get started button gradient 1 & pati button container
    primary: Color(0xFFEF7E06),

    /// get started button gradient 2
    secondary: Color(0xFFF7B327),

    /// scaffold background
    surface: Colors.white,

    /// like polygon gradient 1
    primaryContainer: Color(0xFFF0860B),

    /// like polygon gradient 2
    secondaryContainer: Color(0xFFF6AF24),

    /// bottom nav bar icon
    tertiary: Color(0xFFB0C3CE),

    /// bottom nav bar container
    tertiaryContainer: Colors.white,

    /// like polygon stroke
    outline: Color(0xFFCB8919),

    /// unlike polygon stroke
    outlineVariant: Color(0xFFD1D3D4),

    /// chat receiver bubble
    onTertiaryContainer: Color(0xFFFBD99F),

    /// text color
    scrim: Color(0xFF050405),

    error: Color(0xFFD32F2F),
  );
}

ColorScheme darkColorScheme() {
  return const ColorScheme.dark(
    /// get started button gradient 1 & pati button container
    primary: Color(0xFFAE5D07),

    /// get started button gradient 2
    secondary: Color(0xFFF7B327),

    /// scaffold background
    surface: Color(0xFF050405),

    /// like polygon gradient 1
    primaryContainer: Color(0xFFAE5D07),

    /// like polygon gradient 2
    secondaryContainer: Color(0xFFF7B327),

    /// bottom nav bar icon
    tertiary: Color(0xFFB0C3CE),

    /// bottom nav bar container
    tertiaryContainer: Color(0xFF131313),

    /// like polygon stroke
    outline: Color(0xFFCB8919),

    /// unlike polygon stroke
    outlineVariant: Color(0xFFD1D3D4),

    /// chat receiver bubble
    onTertiaryContainer: Color(0xFFFBD99F),

    /// text color
    scrim: Color(0xFFD4D4D4),

    error: Color(0xFFD32F2F),
  );
}
