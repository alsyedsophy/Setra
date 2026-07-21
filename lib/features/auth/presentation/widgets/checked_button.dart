import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/components/app_button.dart';
import 'package:setra/core/localization/localization.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:setra/features/auth/presentation/cubit/verify%20email/verify_email_cubit.dart';
import 'package:setra/features/auth/presentation/cubit/verify%20email/verify_email_state.dart';

class CheckedButton extends StatelessWidget {
  const CheckedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
      builder: (context, state) {
        return AppButton(
          label: context.l10n.tr(L10nKeys.checked),
          onPressed: () => state is VerifyEmailFinished
              ? context.read<AuthCubit>().checkEmailVerified()
              : null,
        );
      },
    );
  }
}
