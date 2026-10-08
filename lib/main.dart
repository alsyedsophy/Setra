import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/theme/theme_cubit.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:setra/features/category/presentation/cubit/category_cubit.dart';
import 'package:setra/features/home/presentation/cubit/home_cubit.dart';
import 'package:setra/features/products/presentation/cubit/products_cubit.dart';
import 'package:setra/firebase_options.dart';
import 'app/app.dart';
import 'core/dependency_injection/dependency_injection.dart';
import 'core/localization/localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  await initCore();
  // DevicePreview.enable(enabled: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()),
        BlocProvider(create: (context) => getIt<LocaleCubit>()..loadLocale()),
        BlocProvider(create: (context) => getIt<ThemeCubit>()..loadTheme()),
        BlocProvider(create: (context) => getIt<HomeCubit>()),
        BlocProvider(create: (context) => getIt<ProductsCubit>()),
        BlocProvider(create: (context) => getIt<CategoryCubit>()),
      ],
      child: App(),
    );
  }
}
