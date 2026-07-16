import 'package:flutter/material.dart';
import 'package:setra/core/extensions/context_extensions.dart';

import '../design_system/app_spacing.dart';

enum AppButtonVariant { primary, secondary }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final bool isFullWidth;

  VoidCallback? get _effectiveOnPressed => isLoading ? null : onPressed;

  Widget _buildChild(ThemeData theme) {
    if (isLoading) {
      final Color indicatorColor = variant == AppButtonVariant.primary
          ? theme.colorScheme.onPrimary
          : theme.colorScheme.primary;
      return SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: indicatorColor),
      );
    }

    final Widget text = Text(label);

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: AppSpacing.sm),
          text,
        ],
      );
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;
    final Widget child = _buildChild(theme);

    final Widget button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: _effectiveOnPressed,
        child: child,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: _effectiveOnPressed,
        child: child,
      ),
    };

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
