import 'package:flutter/material.dart';

/// Radius tokens for rounded corners.
class AppRadius {
  AppRadius._();

  static const double sm = 4;
  static const double defaultR = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 9999;

  static final BorderRadius smRadius = BorderRadius.circular(sm);
  static final BorderRadius defaultRadius = BorderRadius.circular(defaultR);
  static final BorderRadius mdRadius = BorderRadius.circular(md);
  static final BorderRadius lgRadius = BorderRadius.circular(lg);
  static final BorderRadius xlRadius = BorderRadius.circular(xl);
  static final BorderRadius fullRadius = BorderRadius.circular(full);
}
