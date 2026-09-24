import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/localization/l10n_extension.dart';
import 'package:setra/core/localization/l10n_keys.dart';
import 'package:setra/core/responsive/app_responsive.dart';
import 'package:setra/core/responsive/responsive_layout.dart';
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
      create: (_) => VerifyEmailCubit()..startTimer(),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: ResponsiveLayout(
          mobile: const _VerifyEmailContent(),
          tablet: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: _VerifyEmailContent(),
            ),
          ),
          desktop: Row(
            children: [
              const Expanded(flex: 5, child: _VerifyEmailIllustration()),
              Expanded(
                flex: 4,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: const _VerifyEmailContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerifyEmailContent extends StatelessWidget {
  const _VerifyEmailContent();

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = AppResponsive.value(
      context,
      mobile: AppSpacing.w_24,
      tablet: AppSpacing.w_40,
      desktop: AppSpacing.w_48,
    );
    final double verticalGap = AppResponsive.value(
      context,
      mobile: AppSpacing.h_24,
      tablet: AppSpacing.h_32,
      desktop: AppSpacing.h_40,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthHeader(
          title: context.l10n.tr(L10nKeys.verifyEmail),
          welcome: context.l10n.tr(L10nKeys.welcomeInVerifyEmail),
        ),
        const CheckedButton(),
        verticalGap.hSpace,
        const ResendSection(),
      ],
    ).paddingHorizontal(horizontalPadding);
  }
}

class _VerifyEmailIllustration extends StatelessWidget {
  const _VerifyEmailIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mark_email_read_outlined,
              size: AppResponsive.value(context, mobile: 80, desktop: 160),
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Check your inbox',
              style: TextStyle(
                fontSize: AppResponsive.value(context, mobile: 14, desktop: 18),
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
