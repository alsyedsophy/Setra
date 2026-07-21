import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';

enum ButtonType { primary, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 56,
    this.textStyle,
    this.iconColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final TextStyle? textStyle;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    // TextStyle الفعال (مع الأولوية للـ textStyle الممرر)
    final TextStyle effectiveTextStyle =
        textStyle ??
        theme.textTheme.labelLarge!.copyWith(
          color: type == ButtonType.outlined || type == ButtonType.text
              ? colorScheme.primary
              : colorScheme.onPrimary,
        );

    final child = isLoading
        ? Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: effectiveTextStyle.color,
              ),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: AppSpacing.s_20,
                  color: iconColor ?? effectiveTextStyle.color,
                ),
                AppSpacing.w_8.wSpace,
              ],
              Text(label, style: effectiveTextStyle),
            ],
          );

    Widget button;

    switch (type) {
      case ButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: AppSpacing.r_10.rAll),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: child,
        );
        break;

      case ButtonType.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: effectiveTextStyle.color, // هذا هو الحل الرئيسي
            side: BorderSide(color: colorScheme.outline),
            shape: RoundedRectangleBorder(borderRadius: AppSpacing.r_10.rAll),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: child,
        );
        break;

      case ButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: effectiveTextStyle.color,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: child,
        );
        break;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: button,
    );
  }
}
