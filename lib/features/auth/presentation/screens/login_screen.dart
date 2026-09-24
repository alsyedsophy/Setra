import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/localization/localization.dart';
// ⬇️ الاستيرادات الجديدة
import 'package:setra/core/responsive/app_responsive.dart';
import 'package:setra/core/responsive/responsive_layout.dart';
import 'package:setra/core/widgets/custom_app_bar.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:setra/features/auth/presentation/widgets/auth_header.dart';
import 'package:setra/features/auth/presentation/widgets/auth_layout.dart';
import 'package:setra/features/auth/presentation/widgets/google_login_button.dart';
import 'package:setra/features/auth/presentation/widgets/login_form.dart';
import 'package:setra/features/auth/presentation/widgets/register_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
      appBar: const CustomAppBar(),
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
          return ResponsiveLayout(
            // 🟢 الموبايل: كامل العرض
            mobile: _buildContent(context),

            // 🟡 التابلت: ممركز بعرض أقصى 520
            tablet: _buildContent(context),

            // 🔵 الديسكتوب: صورة جانبية + الفورم
            desktop: Row(
              children: [
                const Expanded(flex: 5, child: _LoginIllustration()),
                Expanded(flex: 4, child: _buildContent(context)),
              ],
            ),
          );
        },
      ),
    );
  }

  /// المحتوى المشترك بين جميع الأحجام
  Widget _buildContent(BuildContext context) {
    // 🎯 مسافات متجاوبة
    final double dividerHorizontalGap = AppResponsive.value(
      context,
      mobile: AppSpacing.w_16,
      tablet: AppSpacing.w_20,
      desktop: AppSpacing.w_24,
    );
    final double gapBeforeGoogle = AppResponsive.value(
      context,
      mobile: AppSpacing.h_48,
      tablet: AppSpacing.h_56,
      desktop: AppSpacing.h_64,
    );
    final double gapBeforeRegister = AppResponsive.value(
      context,
      mobile: AppSpacing.h_72,
      tablet: AppSpacing.h_80,
      desktop: AppSpacing.h_88,
    );

    return AuthLayout(
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
            const Divider(thickness: 1.5).expanded,
            Text(
              context.l10n.tr(L10nKeys.orContinueWith),
              style: context.textTheme.labelSmall,
            ).paddingHorizontal(dividerHorizontalGap),
            const Divider(thickness: 1.5).expanded,
          ],
        ),
        gapBeforeGoogle.hSpace,
        const GoogleLoginButton(),
        gapBeforeRegister.hSpace,
        const RegisterText(),
      ],
    );
  }
}

/// ويدجت جانبي يظهر على الديسكتوب فقط
class _LoginIllustration extends StatelessWidget {
  const _LoginIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorScheme.primary.withValues(alpha: 0.5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: AppResponsive.value(context, mobile: 80, desktop: 160),
              color: context.colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: AppResponsive.value(context, mobile: 14, desktop: 18),
                color: context.colorScheme.primary.withValues(alpha: 0.05),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
