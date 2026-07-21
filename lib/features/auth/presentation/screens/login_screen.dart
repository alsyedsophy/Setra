import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/localization/localization.dart';
import 'package:setra/core/widgets/custom_app_bar.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:setra/features/auth/presentation/widgets/register_text.dart';
import 'package:setra/features/auth/presentation/widgets/google_login_button.dart';
import 'package:setra/features/auth/presentation/widgets/login_form.dart';
import 'package:setra/features/auth/presentation/widgets/auth_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   context.read<AuthCubit>().checkCurrentUser();
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: context.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthHeader(
                  title: context.l10n.tr(L10nKeys.login),
                  welcome: context.l10n.tr(L10nKeys.welcomeInLogin),
                ),
                Form(
                  key: _formKey,
                  child: LoginForm(
                    emailContriller: _emailController,
                    passwordContriller: _passwordController,
                    onLogin: () => _login(),
                  ),
                ),

                Row(
                  children: [
                    Divider(thickness: 1.5).expanded,
                    Text(
                      context.l10n.tr(L10nKeys.orContinueWith),
                      style: context.textTheme.labelSmall,
                    ).paddingHorizontal(AppSpacing.w_16),
                    Divider(thickness: 1.5).expanded,
                  ],
                ),
                AppSpacing.h_48.hSpace,
                GoogleLoginButton(),
                AppSpacing.h_72.hSpace,
                RegisterText(),
              ],
            ).paddingHorizontal(AppSpacing.w_24),
          );
        },
      ),
    );
  }
}
