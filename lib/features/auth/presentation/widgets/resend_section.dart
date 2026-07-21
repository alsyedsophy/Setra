import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/extensions/widget_extensions.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:setra/features/auth/presentation/cubit/verify%20email/verify_email_cubit.dart';
import 'package:setra/features/auth/presentation/cubit/verify%20email/verify_email_state.dart';
import 'package:setra/features/auth/presentation/widgets/circule_timer.dart';

import '../../../../core/localization/localization.dart';

class ResendSection extends StatelessWidget {
  const ResendSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
      builder: (context, state) {
        final isFinished = state is VerifyEmailFinished;
        final seconds = state is VerifyEmailCounting ? state.secondsLeft : 0;
        return Row(
          children: [
            CirculeTimer(seconds: seconds),
            AppSpacing.w_12.wSpace,
            Expanded(
              child:
                  RichText(
                    text: TextSpan(
                      text: context.l10n.tr(L10nKeys.dontReciveEmail),
                      style: context.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: context.l10n.tr(L10nKeys.resend),
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: !isFinished
                                ? context.theme.colorScheme.secondary
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ).onTap(
                    () => isFinished
                        ? () {
                            context.read<AuthCubit>().sendEmailVerification();

                            context.read<VerifyEmailCubit>().resetTimer();
                          }
                        : null,
                  ),
            ),
          ],
        );
      },
    );
  }
}
