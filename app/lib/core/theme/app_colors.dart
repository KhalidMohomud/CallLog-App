import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color seed = Color(0xFF006D77);
  static const Color primary = Color(0xFF006D77);
  static const Color secondary = Color(0xFF5E5CE6);
  static const Color tertiary = Color(0xFFE76F51);
  static const Color error = Color(0xFFBA1A1A);

  static const Color lightSurface = Color(0xFFFAFCFD);
  static const Color lightSurfaceContainer = Color(0xFFEFF5F6);

  static const Color darkSurface = Color(0xFF111819);
  static const Color darkSurfaceContainer = Color(0xFF1C2628);

  static final ColorScheme lightScheme =
      ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
      ).copyWith(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        error: error,
        surface: lightSurface,
        surfaceContainer: lightSurfaceContainer,
      );

  static final ColorScheme darkScheme =
      ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
      ).copyWith(
        secondary: const Color(0xFFBFC2FF),
        tertiary: const Color(0xFFFFB4A2),
        error: const Color(0xFFFFB4AB),
        surface: darkSurface,
        surfaceContainer: darkSurfaceContainer,
      );
}
