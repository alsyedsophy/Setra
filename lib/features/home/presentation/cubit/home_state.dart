import 'package:equatable/equatable.dart';
import 'package:setra/features/home/domain/entities/banner_entity.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<BannerEntity> banners;
  final String? errorMessage;
  final String? selectedCategoryId;

  const HomeState({
    this.status = HomeStatus.initial,
    this.banners = const [],
    this.errorMessage,
    this.selectedCategoryId,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<BannerEntity>? banners,
    String? errorMessage,
    String? selectedCategoryId,
  }) {
    return HomeState(
      status: status ?? this.status,
      banners: banners ?? this.banners,
      errorMessage: errorMessage,
      selectedCategoryId: selectedCategoryId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    banners,
    errorMessage,
    selectedCategoryId,
  ];
}
