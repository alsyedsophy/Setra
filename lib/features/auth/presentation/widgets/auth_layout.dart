import 'package:flutter/material.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/responsive/responsive.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;

        final double horizontalPadding = AppResponsive.valueForWidth<double>(
          availableWidth,
          mobile: 24,
          tablet: 40,
          desktop: 64,
        );

        final double maxContentWidth = AppResponsive.valueForWidth<double>(
          availableWidth,
          mobile: double.infinity,
          tablet: 480,
          desktop: 560,
        );

        final Widget content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        );

        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: content,
            ),
          ).paddingHorizontal(horizontalPadding),
        );
      },
    );
  }
}
