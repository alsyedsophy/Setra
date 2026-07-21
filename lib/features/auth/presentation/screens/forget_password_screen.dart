import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/widgets/custom_app_bar.dart';
import 'package:setra/features/auth/presentation/widgets/auth_header.dart';
import 'package:setra/features/auth/presentation/widgets/forget_form.dart';

import '../../../../core/localization/localization.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthHeader(
            title: context.l10n.tr(L10nKeys.forgetPass),
            welcome: context.l10n.tr(L10nKeys.welcomeForgetPass),
          ),
          ForgetForm(),
        ],
      ).paddingHorizontal(AppSpacing.w_24),
    );
  }
}
