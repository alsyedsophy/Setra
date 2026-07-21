import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/localization/localization.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_cubit.dart';

class ResendForgetText extends StatelessWidget {
  const ResendForgetText({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => context.read<AuthCubit>().sendPasswordReset(email),
        child: RichText(
          text: TextSpan(
            text: context.l10n.tr(L10nKeys.dontReciveEmail),
            style: context.textTheme.bodyMedium,
            children: [
              TextSpan(
                text: context.l10n.tr(L10nKeys.resend),
                style: context.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
