import 'package:flutter/material.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';

/// Side illustration used on wide auth layouts (desktop).
class AuthIllustration extends StatelessWidget {
  const AuthIllustration({
    required this.icon,
    required this.label,
    super.key,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final double iconSize = context.responsive(mobile: 80, desktop: 160);
    final double fontSize = context.responsive(mobile: 14, desktop: 18);
    final double gap = context.responsive(mobile: 12, desktop: 20);

    return Container(
      color: context.colorScheme.primary.withValues(alpha: 0.05),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: context.colorScheme.primary.withValues(alpha: 0.3),
            ),
            gap.hSpace,
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                color: context.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}