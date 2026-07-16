import 'package:flutter/material.dart';
import 'package:setra/core/components/app_button.dart';

import '../design_system/design_system.dart';

/// Full-screen error state with an optional retry action.
///
/// The [message] and [retryLabel] are supplied by the caller and are expected
/// to be localized.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    required this.message,
    this.onRetry,
    this.retryLabel,
    super.key,
  });

  final String message;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final VoidCallback? onRetry = this.onRetry;
    final String? retryLabel = this.retryLabel;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              size: AppSpacing.xl,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            if (onRetry != null && retryLabel != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              AppButton(label: retryLabel, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
