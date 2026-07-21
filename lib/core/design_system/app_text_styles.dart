import 'package:flutter/material.dart';
import 'app_colors.dart'; // تأكد أن الملف موجود ويحتوي على LightColors و DarkColors

class AppTextStyles {
  AppTextStyles._();

  /// يبني [TextTheme] معتمداً على لون النص المناسب للوضع.
  static TextTheme _buildTextTheme(Color onSurfaceColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Geist',
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -0.04,
        color: onSurfaceColor,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Geist',
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: -0.02,
        color: onSurfaceColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Geist',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: onSurfaceColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: onSurfaceColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: onSurfaceColor,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: onSurfaceColor,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Geist',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.0,
        letterSpacing: 0.02,
        color: onSurfaceColor,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Geist',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.1,
        color: onSurfaceColor,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Geist',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: onSurfaceColor,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Geist',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.15,
        color: onSurfaceColor,
      ),
    );
  }

  static final TextTheme lightTextTheme = _buildTextTheme(
    LightColors.onSurface,
  );
  static final TextTheme darkTextTheme = _buildTextTheme(DarkColors.onSurface);
}
