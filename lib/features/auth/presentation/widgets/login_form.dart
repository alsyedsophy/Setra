import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/components/app_text_field.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/extensions/widget_extensions.dart';
import 'package:setra/core/localization/localization.dart';
import 'package:setra/core/routing/route_paths.dart';
import 'package:setra/core/utils/validators.dart';
import 'package:setra/features/auth/presentation/widgets/login_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this._emailContriller,
    required this._passwordContriller,
    required this._onLogin,
  });

  final TextEditingController _emailContriller;
  final TextEditingController _passwordContriller;
  final VoidCallback _onLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.tr(L10nKeys.email),
          style: context.textTheme.labelMedium,
        ),
        AppSpacing.h_4.hSpace,
        AppTextField(
          controller: _emailContriller,
          hint: 'name@example.com',
          keyboardType: TextInputType.emailAddress,
          validator: (value) => AppValidators.email(value),
        ),
        AppSpacing.h_24.hSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.tr(L10nKeys.password),
              style: context.textTheme.labelMedium,
            ),
            Text(
              context.l10n.tr(L10nKeys.forgotPassword),
              style: context.textTheme.labelMedium,
            ).onTap(() {
              context.pushNamed(RoutePaths.forgetPasswodName);
            }),
          ],
        ),
        AppSpacing.h_4.hSpace,
        AppTextField(
          controller: _passwordContriller,
          hint: '••••••••',
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          validator: (value) => AppValidators.password(value),
        ),
        AppSpacing.h_24.hSpace,
        LoginButton(onLogin: _onLogin, title: context.l10n.tr(L10nKeys.signIn)),
        AppSpacing.h_48.hSpace,
      ],
    );
  }
}
