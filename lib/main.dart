import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/theme/theme_cubit.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:setra/firebase_options.dart';

import 'app/app.dart';
import 'core/dependency_injection/dependency_injection.dart';
// import 'core/extensions/extensions.dart';
import 'core/localization/localization.dart';
// import 'core/widgets/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  await initCore();
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
      ],
      child: App(),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(context.l10n.tr('appName')),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 8),
//             child: LocaleToggle(),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Text(
//           context.l10n.tr('emptyGeneric'),
//           style: context.textTheme.bodyLarge,
//         ),
//       ),
//     );
//   }
// }
