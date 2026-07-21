import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/components/app_button.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_state.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, required this._onLogin, required this.title});
  final String title;

  final VoidCallback _onLogin;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return AppButton(
          label: title,
          textStyle: context.textTheme.labelLarge?.copyWith(
            color: context.theme.colorScheme.surface,
          ),
          onPressed: state.status == AuthStatus.loading ? null : _onLogin,
        );
      },
    );
  }
}
