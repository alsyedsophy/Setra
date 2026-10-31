import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';

class CheckoutMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const CheckoutMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48),
          AppSpacing.h_16.hSpace,
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium,
          ),
          AppSpacing.h_8.hSpace,
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            AppSpacing.h_16.hSpace,
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ).paddingAll(AppSpacing.w_24),
    );
  }
}
