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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.h_32.hSpace,
        Align(
          alignment: Alignment.center,
          child: Text(title, style: context.textTheme.displayLarge),
        ),
        AppSpacing.h_8.hSpace,
        Center(child: Text(welcome, style: context.textTheme.bodySmall)),
        AppSpacing.h_48.hSpace,
      ],
    );
  }
}
