import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.welcome});
  final String title;
  final String welcome;

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleStyle = context.responsive<TextStyle?>(
      mobile: context.textTheme.headlineLarge,
      desktop: context.textTheme.displayLarge,
    );

    final double topGap = context.responsive(
      mobile: AppSpacing.h_32,
      tablet: AppSpacing.h_40,
    );
    final double bottomGap = context.responsive(
      mobile: AppSpacing.h_48,
      tablet: AppSpacing.h_56,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        topGap.hSpace,
        Align(
          alignment: Alignment.center,
          child: Text(title, style: titleStyle),
        ),
        AppSpacing.h_8.hSpace,
        Center(child: Text(welcome, style: context.textTheme.bodySmall)),
        bottomGap.hSpace,
      ],
    );
  }
}
