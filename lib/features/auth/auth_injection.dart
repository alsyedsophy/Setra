import 'package:setra/core/network/network_info.dart';
import 'package:setra/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:setra/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:setra/features/auth/domain/repositories/auth_repository.dart';
import 'package:setra/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:setra/features/auth/domain/usecases/check_verification_email_use_case.dart';
import 'package:setra/features/auth/domain/usecases/send_email_verification_use_case.dart';
import 'package:setra/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> registerAuthentication() async {
  final GetIt getIt = GetIt.instance;

  final firabaseAuth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn.instance;

  getIt.registerLazySingleton<FirebaseAuth>(() => firabaseAuth);
  getIt.registerLazySingleton<GoogleSignIn>(() => googleSignIn);

  // Data sources.
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
      googleSignIn: getIt<GoogleSignIn>(),
    ),
  );

  // Repositories.
  getIt.registerLazySingleton<AuthRepository>(
    () =>
        AuthRepositoryImpl(getIt<AuthRemoteDataSource>(), getIt<NetworkInfo>()),
  );

  // Use cases (stateless).
  getIt.registerLazySingleton<AuthStateChangesUseCase>(
    () => AuthStateChangesUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<GoogleSignInUseCase>(
    () => GoogleSignInUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<CheckVerificationEmailUseCase>(
    () => CheckVerificationEmailUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SendEmailVerificationUseCase>(
    () => SendEmailVerificationUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SendPasswordResetUseCase>(
    () => SendPasswordResetUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(authRepository: getIt<AuthRepository>()),
  );

  // Cubits.

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      logInUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      signInWithGoogleUseCase: getIt<GoogleSignInUseCase>(),
      sendPasswordResetUseCase: getIt<SendPasswordResetUseCase>(),
      logOutUseCase: getIt<LogoutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
      authStateChangesUseCase: getIt<AuthStateChangesUseCase>(),
      sendEmailVerificationUseCase: getIt<SendEmailVerificationUseCase>(),
      checkVerificationEmailUseCase: getIt<CheckVerificationEmailUseCase>(),
    ),
  );
}
