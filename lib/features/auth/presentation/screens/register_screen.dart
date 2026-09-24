import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
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
import 'package:setra/features/auth/presentation/widgets/login_text.dart';
import 'package:setra/features/auth/presentation/widgets/register_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmePassController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmePassController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.failure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        child: ResponsiveLayout(
          // 🟢 الموبايل: كامل العرض
          mobile: _buildContent(context),

          // 🟡 التابلت: ممركز بعرض أقصى 560 (أوسع قليلاً من Login بسبب عدد الحقول)
          tablet: _buildContent(context),

          // 🔵 الديسكتوب: صورة جانبية + الفورم
          desktop: Row(
            children: [
              const Expanded(flex: 5, child: _RegisterIllustration()),
              Expanded(flex: 4, child: _buildContent(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final double gapBeforeLoginText = AppResponsive.value(
      context,
      mobile: AppSpacing.h_24,
      tablet: AppSpacing.h_32,
      desktop: AppSpacing.h_40,
    );

    return AuthLayout(
      children: [
        AuthHeader(
          title: context.l10n.tr(L10nKeys.uCreateAccount),
          welcome: context.l10n.tr(L10nKeys.welcomeInRegister),
        ),
        Form(
          key: _formKey,
          child: RegisterForm(
            nameController: _nameController,
            emailController: _emailController,
            passwordController: _passwordController,
            confirmePassController: _confirmePassController,
            onRegister: _register,
          ),
        ),
        gapBeforeLoginText.hSpace,
        const LoginText(),
      ],
    );
  }
}

class _RegisterIllustration extends StatelessWidget {
  const _RegisterIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorScheme.primary.withValues(alpha: 0.05),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_alt_1_outlined,
              size: AppResponsive.value(context, mobile: 80, desktop: 160),
              color: context.colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Join Us Today',
              style: TextStyle(
                fontSize: AppResponsive.value(context, mobile: 14, desktop: 18),
                color: context.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
