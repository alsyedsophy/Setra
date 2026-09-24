import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// import '../core/dependency_injection/dependency_injection.dart';
import '../core/design_system/design_system.dart';
import '../core/localization/localization.dart';
import '../core/routing/routing.dart';
import '../core/theme/theme.dart';

class App extends StatelessWidget {
  App({super.key});

  final GoRouter _router = AppRouter.create();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 837),
      minTextAdapt: true,
      builder: (context, child) => EasyLocalization(
        supportedLocales: supportedLocales,
        path: translationsPath,
        fallbackLocale: fallbackLocale,
        useOnlyLangCode: true,
        // startLocale: getIt<LocaleCubit>().state.locale,
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              onGenerateTitle: (BuildContext context) =>
                  context.l10n.tr('appName'),
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeState.themeMode,
              routerConfig: _router,
            );
          },
        ),
      ),
    );
  }
}
