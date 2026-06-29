import 'package:flutter/material.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.success,
    required this.warning,
    required this.info,
    required this.elevatedSurface,
    required this.strongDivider,
  });

  final Color success;
  final Color warning;
  final Color info;
  final Color elevatedSurface;
  final Color strongDivider;

  static const AppThemeExtension light = AppThemeExtension(
    success: Color(0xFF2E7D32),
    warning: Color(0xFFF59E0B),
    info: Color(0xFF1565C0),
    elevatedSurface: Color(0xFFFFFFFF),
    strongDivider: Color(0xFFD4E1E4),
  );

  static const AppThemeExtension dark = AppThemeExtension(
    success: Color(0xFF81C784),
    warning: Color(0xFFFBBF24),
    info: Color(0xFF90CAF9),
    elevatedSurface: Color(0xFF202B2D),
    strongDivider: Color(0xFF334346),
  );

  @override
  AppThemeExtension copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? elevatedSurface,
    Color? strongDivider,
  }) {
    return AppThemeExtension(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      elevatedSurface: elevatedSurface ?? this.elevatedSurface,
      strongDivider: strongDivider ?? this.strongDivider,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }

    return AppThemeExtension(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      elevatedSurface: Color.lerp(elevatedSurface, other.elevatedSurface, t)!,
      strongDivider: Color.lerp(strongDivider, other.strongDivider, t)!,
    );
  }
}
