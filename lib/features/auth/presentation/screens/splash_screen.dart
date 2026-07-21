import 'package:setra/core/components/components.dart';
import 'package:flutter/material.dart';

/// Shown while the initial auth state is resolved. The GoRouter redirect
/// guard moves away from this screen once [AuthCubit] emits a definitive
/// authenticated/unauthenticated status.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: AppLoading());
}
