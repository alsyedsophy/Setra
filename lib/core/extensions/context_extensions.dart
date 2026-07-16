import 'package:flutter/material.dart';

import '../responsive/responsive.dart';

/// Convenience accessors for the most common [BuildContext] lookups.
extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  bool get isMobile => AppResponsive.isMobile(this);
  bool get isTablet => AppResponsive.isTablet(this);
  bool get isDesktop => AppResponsive.isDesktop(this);
  AppBreakpoint get breakpoint => AppResponsive.breakpointOf(this);
}
