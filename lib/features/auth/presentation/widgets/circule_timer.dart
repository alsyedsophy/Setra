import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';

class CirculeTimer extends StatelessWidget {
  const CirculeTimer({super.key, required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.h_40,
      width: AppSpacing.w_40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: (seconds / 60).clamp(0.0, 1.0),
            strokeWidth: 3,
            color: context.theme.colorScheme.primary,
          ),
          Text('$seconds', style: context.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
