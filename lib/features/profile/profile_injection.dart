import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:setra/core/dependency_injection/dependency_injection.dart';
import 'package:setra/core/network/network_info.dart';
import 'package:setra/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:setra/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:setra/features/profile/domain/repositories/profile_repository.dart';
import 'package:setra/features/profile/domain/use_cases/create_profile_use_case.dart';
import 'package:setra/features/profile/domain/use_cases/ensure_profile_use_case.dart';
import 'package:setra/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:setra/features/profile/domain/use_cases/update_profile_use_case.dart';
import 'package:setra/features/profile/presentation/cubit/profile_cubit.dart';

Future<void> registerProfile() async {
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
      firebaseAuth: getIt<FirebaseAuth>(),
    ),
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      getIt<ProfileRemoteDataSource>(),
      getIt<NetworkInfo>(),
    ),
  );

  getIt.registerLazySingleton<CreateProfileUseCase>(
    () => CreateProfileUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<EnsureProfileUseCase>(
    () => EnsureProfileUseCase(getIt<ProfileRepository>()),
  );

  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getProfileUseCase: getIt<GetProfileUseCase>(),
      updateProfileUseCase: getIt<UpdateProfileUseCase>(),
    ),
  );
}
