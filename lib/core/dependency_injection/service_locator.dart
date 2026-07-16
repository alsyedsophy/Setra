import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/locale_cubit.dart';
import '../services/logger_service.dart';
import '../storage/local_storage_service.dart';
import '../storage/storage_service.dart';
import '../theme/theme_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> initCore() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();

  // Shared services (singletons).
  getIt.registerLazySingleton<SharedPreferences>(() => preferences);
  getIt.registerLazySingleton<LoggerService>(() => AppLogger());
  getIt.registerLazySingleton<StorageService>(
    () => LocalStorageService(getIt<SharedPreferences>()),
  );

  // Cubits (factory: a new instance per screen).
  getIt.registerFactory<ThemeCubit>(() => ThemeCubit(getIt<StorageService>()));

  // App-global locale state (single source of truth for the active language).
  getIt.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(getIt<StorageService>()),
  );

  //? ============ Auth ==============
  // await registerAuthentication();
}
