import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:setra/core/network/network_info.dart';
import 'package:setra/features/category/data/datasources/category_remote_data_source.dart';
import 'package:setra/features/category/data/repositories/category_repository_impl.dart';
import 'package:setra/features/category/domain/repositories/category_repository.dart';
import 'package:setra/features/category/domain/usecases/get_categories_for_gender_use_case.dart';
import 'package:setra/features/category/domain/usecases/get_categories_use_case.dart';
import 'package:setra/features/category/domain/usecases/get_category_by_id_use_case.dart';
import 'package:setra/features/category/domain/usecases/get_featured_category.dart';
import 'package:setra/features/category/presentation/cubit/category_cubit.dart';

Future<void> registerCategory() async {
  final GetIt getIt = GetIt.instance;

  // Data sources
  getIt.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );

  // Repositories
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      getIt<CategoryRemoteDataSource>(),
      getIt<NetworkInfo>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(getIt<CategoryRepository>()),
  );
  getIt.registerLazySingleton<GetCategoryByIdUseCase>(
    () => GetCategoryByIdUseCase(getIt<CategoryRepository>()),
  );

  getIt.registerLazySingleton<GetFeaturedCategoriesUseCase>(
    () => GetFeaturedCategoriesUseCase(getIt<CategoryRepository>()),
  );

  getIt.registerLazySingleton<GetCategoriesForGenderUseCase>(
    () => GetCategoriesForGenderUseCase(getIt<CategoryRepository>()),
  );

  // Cubits
  getIt.registerFactory<CategoryCubit>(
    () => CategoryCubit(
      getCategoriesUseCase: getIt<GetCategoriesUseCase>(),
      getCategoryByIdUseCase: getIt<GetCategoryByIdUseCase>(),
      getFeaturedCategoriesUseCase: getIt<GetFeaturedCategoriesUseCase>(),
      getCategoriesForGenderUseCase: getIt<GetCategoriesForGenderUseCase>(),
    ),
  );
}
