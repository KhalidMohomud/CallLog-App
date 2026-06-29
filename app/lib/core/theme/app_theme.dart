import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_theme_extension.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(
    colorScheme: AppColors.lightScheme,
    extension: AppThemeExtension.light,
  );

  static ThemeData get dark => _build(
    colorScheme: AppColors.darkScheme,
    extension: AppThemeExtension.dark,
  );

  static ThemeData _build({
    required ColorScheme colorScheme,
    required AppThemeExtension extension,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainer,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
      ),
      extensions: <ThemeExtension<dynamic>>[extension],
    );
  }
}
