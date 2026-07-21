import 'package:flutter/material.dart';

extension NumExtensions on num {
  // ================= SPACING =================
  SizedBox get hSpace => SizedBox(height: toDouble());
  SizedBox get wSpace => SizedBox(width: toDouble());

  // ================= PADDING =================
  EdgeInsets get pAll => EdgeInsets.all(toDouble());

  EdgeInsets get pH => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get pV => EdgeInsets.symmetric(vertical: toDouble());

  EdgeInsets get pTop => EdgeInsets.only(top: toDouble());
  EdgeInsets get pBottom => EdgeInsets.only(bottom: toDouble());
  EdgeInsets get pLeft => EdgeInsets.only(left: toDouble());
  EdgeInsets get pRight => EdgeInsets.only(right: toDouble());

  EdgeInsets get pTL => EdgeInsets.only(top: toDouble(), left: toDouble());
  EdgeInsets get pTR => EdgeInsets.only(top: toDouble(), right: toDouble());
  EdgeInsets get pBL => EdgeInsets.only(bottom: toDouble(), left: toDouble());
  EdgeInsets get pBR => EdgeInsets.only(bottom: toDouble(), right: toDouble());

  EdgeInsets pOnly({double? top, double? bottom, double? left, double? right}) {
    return EdgeInsets.only(
      top: top ?? toDouble(),
      bottom: bottom ?? toDouble(),
      left: left ?? toDouble(),
      right: right ?? toDouble(),
    );
  }

  // ================= MARGIN =================
  EdgeInsets get mAll => EdgeInsets.all(toDouble());

  EdgeInsets get mH => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get mV => EdgeInsets.symmetric(vertical: toDouble());

  EdgeInsets get mTop => EdgeInsets.only(top: toDouble());
  EdgeInsets get mBottom => EdgeInsets.only(bottom: toDouble());
  EdgeInsets get mLeft => EdgeInsets.only(left: toDouble());
  EdgeInsets get mRight => EdgeInsets.only(right: toDouble());

  EdgeInsets get mTL => EdgeInsets.only(top: toDouble(), left: toDouble());
  EdgeInsets get mTR => EdgeInsets.only(top: toDouble(), right: toDouble());
  EdgeInsets get mBL => EdgeInsets.only(bottom: toDouble(), left: toDouble());
  EdgeInsets get mBR => EdgeInsets.only(bottom: toDouble(), right: toDouble());
  EdgeInsets get marginRTB => EdgeInsets.only(
    right: toDouble(),
    top: toDouble(),
    bottom: toDouble(),
    left: 0,
  );

  EdgeInsets mOnly({double? top, double? bottom, double? left, double? right}) {
    return EdgeInsets.only(
      top: top ?? toDouble(),
      bottom: bottom ?? toDouble(),
      left: left ?? toDouble(),
      right: right ?? toDouble(),
    );
  }

  // ================= BORDER RADIUS =================
  BorderRadius get rAll => BorderRadius.circular(toDouble());

  BorderRadius get rTop =>
      BorderRadius.vertical(top: Radius.circular(toDouble()));

  BorderRadius get rBottom =>
      BorderRadius.vertical(bottom: Radius.circular(toDouble()));

  BorderRadius get rLeft =>
      BorderRadius.horizontal(left: Radius.circular(toDouble()));

  BorderRadius get rRight =>
      BorderRadius.horizontal(right: Radius.circular(toDouble()));

  BorderRadius get rTL =>
      BorderRadius.only(topLeft: Radius.circular(toDouble()));

  BorderRadius get rTR =>
      BorderRadius.only(topRight: Radius.circular(toDouble()));

  BorderRadius get rBL =>
      BorderRadius.only(bottomLeft: Radius.circular(toDouble()));

  BorderRadius get rBR =>
      BorderRadius.only(bottomRight: Radius.circular(toDouble()));
}
