import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/components/app_text_field.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/localization/localization.dart';
import 'package:setra/core/utils/utils.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:setra/features/auth/presentation/widgets/forget_submit_button.dart';
import 'package:setra/features/auth/presentation/widgets/resend_forget_text.dart';

class ForgetForm extends StatefulWidget {
  const ForgetForm({super.key});

  @override
  State<ForgetForm> createState() => _ForgetFormState();
}

class _ForgetFormState extends State<ForgetForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().sendPasswordReset(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? context.l10n.tr(L10nKeys.error),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.tr(L10nKeys.email),
                style: context.textTheme.bodyMedium,
              ),
              AppSpacing.h_6.hSpace,

              AppTextField(
                hint: 'example@gmail.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => AppValidators.email(value),
              ),

              AppSpacing.h_30.hSpace,

              ForgotSubmitButton(
                isLoading: state.status == AuthStatus.loading,
                onPressed: _submit,
              ),

              AppSpacing.h_20.hSpace,
              ResendForgetText(email: _emailController.text.trim()),
            ],
          ),
        );
      },
    );
  }
}
