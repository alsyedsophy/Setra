import 'package:flutter/material.dart';
import 'package:setra/core/components/app_text_field.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/localization/localization.dart';
import 'package:setra/core/utils/validators.dart';
import 'package:setra/features/auth/presentation/widgets/login_button.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this._nameController,
    required this._emailController,
    required this._passwordController,
    required this._confirmePassController,
    required this._onRegister,
  });
  final TextEditingController _nameController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final TextEditingController _confirmePassController;
  final VoidCallback _onRegister;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.tr(L10nKeys.name),
          style: context.textTheme.labelMedium,
        ),
        AppSpacing.h_4.hSpace,
        AppTextField(
          controller: _nameController,
          hint: context.l10n.tr(L10nKeys.nameField),
          keyboardType: TextInputType.name,
          validator: (value) => AppValidators.required(value),
        ),
        AppSpacing.h_24.hSpace,
        Text(
          context.l10n.tr(L10nKeys.email),
          style: context.textTheme.labelMedium,
        ),
        AppSpacing.h_4.hSpace,
        AppTextField(
          controller: _emailController,
          hint: 'name@example.com',
          keyboardType: TextInputType.emailAddress,
          validator: (value) => AppValidators.email(value),
        ),
        AppSpacing.h_24.hSpace,
        Text(
          context.l10n.tr(L10nKeys.password),
          style: context.textTheme.labelMedium,
        ),
        AppSpacing.h_4.hSpace,
        AppTextField(
          controller: _passwordController,
          hint: '••••••••',
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          validator: (value) => AppValidators.password(value),
        ),
        AppSpacing.h_24.hSpace,
        Text(
          context.l10n.tr(L10nKeys.confirmePass),
          style: context.textTheme.labelMedium,
        ),
        AppSpacing.h_4.hSpace,
        AppTextField(
          controller: _confirmePassController,
          hint: '••••••••',
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          validator: (value) => AppValidators.confirmPassword(
            value,
            _passwordController.text.trim(),
          ),
        ),
        AppSpacing.h_48.hSpace,
        LoginButton(
          onLogin: _onRegister,
          title: context.l10n.tr(L10nKeys.uCreateAccount),
        ),
        AppSpacing.h_48.hSpace,
      ],
    );
  }
}
