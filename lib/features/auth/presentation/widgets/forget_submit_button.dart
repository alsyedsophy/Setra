import 'package:flutter/material.dart';
import 'package:setra/core/components/app_button.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/localization/localization.dart';

class ForgotSubmitButton extends StatelessWidget {
  const ForgotSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: context.l10n.tr(L10nKeys.resend),
      height: AppSpacing.h_56,
      width: double.infinity,
      type: ButtonType.primary,
      onPressed: isLoading ? null : onPressed,
    );
  }
}
