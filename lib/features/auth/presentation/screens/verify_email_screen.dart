import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/localization/l10n_extension.dart';
import 'package:setra/core/localization/l10n_keys.dart';
import 'package:setra/core/widgets/custom_app_bar.dart';
import 'package:setra/features/auth/presentation/cubit/verify%20email/verify_email_cubit.dart';
import 'package:setra/features/auth/presentation/widgets/auth_header.dart';
import 'package:setra/features/auth/presentation/widgets/checked_button.dart';
import 'package:setra/features/auth/presentation/widgets/resend_section.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerifyEmailCubit()..startTimer(),
      child: Scaffold(
        appBar: CustomAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthHeader(
              title: context.l10n.tr(L10nKeys.verifyEmail),
              welcome: context.l10n.tr(L10nKeys.welcomeInVerifyEmail),
            ),
            CheckedButton(),
            AppSpacing.h_24.hSpace,
            // Circule Counter
            ResendSection(),
          ],
        ).paddingHorizontal(AppSpacing.w_24),
      ),
    );
  }
}
