import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:setra/core/network/network_info.dart';
import 'package:setra/features/home/domain/usecases/get_featured_use_case.dart';
import 'package:setra/features/home/domain/usecases/get_new_arrival_use_case.dart';
import 'package:setra/features/home/domain/usecases/get_products_by_gender_use_case.dart';
import 'package:setra/features/home/domain/usecases/get_products_by_tags_use_case.dart';
import 'package:setra/features/home/domain/usecases/get_products_use_case.dart';

import 'data/datasources/home_remote_data_source.dart';
import 'data/repositories/home_repository_impl.dart';
import 'domain/repositories/home_repository.dart';
import 'domain/usecases/get_banners_use_case.dart';
import 'domain/usecases/get_categories_use_case.dart';
import 'domain/usecases/get_products_by_category_use_case.dart';
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
  getIt.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetNewArrivalUseCase>(
    () => GetNewArrivalUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetFeaturedUseCase>(
    () => GetFeaturedUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetProductsByCategoryUseCase>(
    () => GetProductsByCategoryUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetProductsByGenderUseCase>(
    () => GetProductsByGenderUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton<GetProductsByTagsUseCase>(
    () => GetProductsByTagsUseCase(getIt<HomeRepository>()),
  );

  // Cubits
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(
      getBannersUseCase: getIt<GetBannersUseCase>(),
      getCategoriesUseCase: getIt<GetCategoriesUseCase>(),
      getProductsUseCase: getIt<GetProductsUseCase>(),
      getNewArrivalUseCase: getIt<GetNewArrivalUseCase>(),
      getFeaturedUseCase: getIt<GetFeaturedUseCase>(),
      getProductsByCategoryUseCase: getIt<GetProductsByCategoryUseCase>(),
      getProductsByGenderUseCase: getIt<GetProductsByGenderUseCase>(),
      getProductsByTagsUseCase: getIt<GetProductsByTagsUseCase>(),
    ),
  );
}
