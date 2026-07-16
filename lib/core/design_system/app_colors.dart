import 'package:flutter/material.dart';

/// ألوان Setra Premium – الوضع الفاتح
class LightColors {
  LightColors._();

  // Primary (أسود خام)
  static const Color primary = Color(0xFF000000);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF1B1B1B);
  static const Color onPrimaryContainer = Color(0xFF848484);

  // Secondary (رمادي غامق)
  static const Color secondary = Color(0xFF5E5E5E);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE3E2E2);
  static const Color onSecondaryContainer = Color(0xFF646464);

  // Tertiary (متطابق مع primary في التصميم الأحادي)
  static const Color tertiary = Color(0xFF000000);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF1A1C1C);
  static const Color onTertiaryContainer = Color(0xFF838484);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Surface & Background
  static const Color surface = Color(0xFFF9F9F9);
  static const Color onSurface = Color(0xFF1A1C1C);
  static const Color surfaceVariant = Color(0xFFE2E2E2);
  static const Color onSurfaceVariant = Color(0xFF4C4546);

  static const Color background = Color(0xFFF9F9F9);
  static const Color onBackground = Color(0xFF1A1C1C);

  // Outlines
  static const Color outline = Color(0xFF7E7576);
  static const Color outlineVariant = Color(0xFFCFC4C5);

  // Convenience
  static const Color scaffoldBackground = surface;
}

/// ألوان Setra Premium – الوضع الداكن
/// (معكوسة للحفاظ على التباين والطابع الأحادي الفاخر)
class DarkColors {
  DarkColors._();

  // Primary (أبيض ناصع)
  static const Color primary = Color(0xFFFFFFFF);
  static const Color onPrimary = Color(0xFF000000);
  static const Color primaryContainer = Color(0xFF333333);
  static const Color onPrimaryContainer = Color(0xFFCCCCCC);

  // Secondary (رمادي متوسط فاتح)
  static const Color secondary = Color(0xFFBBBBBB);
  static const Color onSecondary = Color(0xFF1A1C1C);
  static const Color secondaryContainer = Color(0xFF3A3A3A);
  static const Color onSecondaryContainer = Color(0xFFD6D6D6);

  // Tertiary (أبيض)
  static const Color tertiary = Color(0xFFFFFFFF);
  static const Color onTertiary = Color(0xFF000000);
  static const Color tertiaryContainer = Color(0xFF2F3131);
  static const Color onTertiaryContainer = Color(0xFFC6C6C7);

  // Error
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // Surface & Background
  static const Color surface = Color(0xFF1A1C1C);
  static const Color onSurface = Color(0xFFE0E0E0);
  static const Color surfaceVariant = Color(0xFF2F3131);
  static const Color onSurfaceVariant = Color(0xFFC6C6C6);

  static const Color background = Color(0xFF1A1C1C);
  static const Color onBackground = Color(0xFFE0E0E0);

  // Outlines
  static const Color outline = Color(0xFF938F99);
  static const Color outlineVariant = Color(0xFF49454F);

  // Convenience
  static const Color scaffoldBackground = surface;
}
