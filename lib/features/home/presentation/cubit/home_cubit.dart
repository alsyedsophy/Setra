import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/features/home/domain/usecases/get_banners_use_case.dart';
import 'package:setra/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetBannersUseCase _getBannersUseCase;

  HomeCubit({required this._getBannersUseCase}) : super(const HomeState());

  Future<void> loadHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));

    final bannersResult = await _getBannersUseCase();

    final List<Exception> failures = [];

    bannersResult.fold(
      (failure) => failures.add(Exception(failure.message)),
      (banners) => emit(state.copyWith(banners: banners)),
    );

    if (failures.isNotEmpty) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: failures.map((e) => e.toString()).join(', '),
        ),
      );
    } else {
      emit(state.copyWith(status: HomeStatus.loaded, errorMessage: null));
    }
  }

  Future<void> loadBanner() async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));

    final result = await _getBannersUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(status: HomeStatus.error, errorMessage: failure.message),
      ),
      (banners) =>
          emit(state.copyWith(status: HomeStatus.loaded, banners: banners)),
    );
  }

  void clearError() {
    log("Delete Dialog");
    emit(state.copyWith(status: HomeStatus.loaded, errorMessage: ""));
  }
}
