import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/components/app_button.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/localization/localization.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_cubit.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppButton(
        label: context.l10n.tr(L10nKeys.google),
        textStyle: context.textTheme.labelMedium,
        icon: Icons.g_mobiledata,
        onPressed: () => context.read<AuthCubit>().signInWithGoogle(),
        type: ButtonType.outlined,
        width: AppSpacing.w_170,
        height: AppSpacing.h_50,
      ),
    );
  }
}
