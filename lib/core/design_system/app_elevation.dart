import 'package:flutter/material.dart';

class AppElevation {
  AppElevation._();

  // Level 1: Whisper Shadow (0px 4px 20px, 4% Black opacity)
  static final List<BoxShadow> level1 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      offset: const Offset(0, 4),
      blurRadius: 20.0,
      spreadRadius: 0,
    ),
  ];

  // Level 2: Active/Modals (0px 10px 30px, 8% Black opacity + border)
  static final List<BoxShadow> level2 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      offset: const Offset(0, 10),
      blurRadius: 30.0,
      spreadRadius: 0,
    ),
  ];

  // Decoration helper for Level 2 with border
  static BoxDecoration level2Decoration({
    required Color backgroundColor,
    required BorderRadius borderRadius,
    Color borderColor = const Color(0xFFE5E5E5),
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: borderRadius,
      border: Border.all(color: borderColor, width: 1.0),
      boxShadow: level2,
    );
  }
}
