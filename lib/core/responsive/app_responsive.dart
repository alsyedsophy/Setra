import 'package:flutter/widgets.dart';

import 'breakpoints.dart';

class AppResponsive {
  AppResponsive._();

  static AppBreakpoint breakpointForWidth(double width) {
    if (width >= AppBreakpoints.desktop) {
      return AppBreakpoint.desktop;
    }
    if (width >= AppBreakpoints.tablet) {
      return AppBreakpoint.tablet;
    }
    return AppBreakpoint.mobile;
  }

  static AppBreakpoint breakpointOf(BuildContext context) =>
      breakpointForWidth(MediaQuery.sizeOf(context).width);

  //? ========= not important enugth ===========

  static bool isMobile(BuildContext context) =>
      breakpointOf(context) == AppBreakpoint.mobile;

  static bool isTablet(BuildContext context) =>
      breakpointOf(context) == AppBreakpoint.tablet;

  static bool isDesktop(BuildContext context) =>
      breakpointOf(context) == AppBreakpoint.desktop;

  /// Recommended grid column count for the active breakpoint.
  static int gridColumnsFor(AppBreakpoint breakpoint) {
    switch (breakpoint) {
      case AppBreakpoint.mobile:
        return 2;
      case AppBreakpoint.tablet:
        return 3;
      case AppBreakpoint.desktop:
        return 4;
    }
  }

  //? =====================================

  static T valueForWidth<T>(
    double width, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    switch (breakpointForWidth(width)) {
      case AppBreakpoint.desktop:
        return desktop ?? tablet ?? mobile;
      case AppBreakpoint.tablet:
        return tablet ?? mobile;
      case AppBreakpoint.mobile:
        return mobile;
    }
  }

  /// Returns the value matching the active breakpoint, falling back to smaller
  /// breakpoints when a larger one is not provided.
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) => valueForWidth(
    MediaQuery.sizeOf(context).width,
    mobile: mobile,
    tablet: tablet,
    desktop: desktop,
  );
}
