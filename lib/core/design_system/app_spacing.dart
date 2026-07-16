import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double base = 8.0;
  static const double xs = 4.0;
  static const double sm = 12.0;
  static const double md = 24.0;
  static const double lg = 48.0;
  static const double xl = 80.0;

  // Layout Constraints
  static const double containerMax = 1440.0;
  static const double gutter = 24.0;
  static const double marginMobile = 16.0;
  static const double marginDesktop = 64.0;

  // Helper EdgeInsets for easy development
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);

  static const EdgeInsets marginMobileHorizontal = EdgeInsets.symmetric(
    horizontal: marginMobile,
  );
  static const EdgeInsets marginDesktopHorizontal = EdgeInsets.symmetric(
    horizontal: marginDesktop,
  );
}
