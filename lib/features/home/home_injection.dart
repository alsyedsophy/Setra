import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:setra/core/network/network_info.dart';

import 'data/datasources/home_remote_data_source.dart';
import 'data/repositories/home_repository_impl.dart';
import 'domain/repositories/home_repository.dart';
import 'domain/usecases/get_banners_use_case.dart';
import 'presentation/cubit/home_cubit.dart';

Future<void> registerHome() async {
  final GetIt getIt = GetIt.instance;

  final fireStore = FirebaseFirestore.instance;
  getIt.registerLazySingleton<FirebaseFirestore>(() => fireStore);

  // Data sources
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(firestore: getIt<FirebaseFirestore>()),
  );

  // Repositories
  getIt.registerLazySingleton<HomeRepository>(
    () =>
        HomeRepositoryImpl(getIt<HomeRemoteDataSource>(), getIt<NetworkInfo>()),
  );

  // Use cases
  getIt.registerLazySingleton<GetBannersUseCase>(
    () => GetBannersUseCase(getIt<HomeRepository>()),
  );

  // Cubits
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(getBannersUseCase: getIt<GetBannersUseCase>()),
  );
}
