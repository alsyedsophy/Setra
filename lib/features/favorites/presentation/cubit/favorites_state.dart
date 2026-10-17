import 'package:equatable/equatable.dart';
import 'package:setra/features/favorites/domain/entities/favorite_entity.dart';

enum FavoritesStatus { initial, loading, success, failure }

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final List<FavoriteItem> items;
  final String? errorMessage;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  bool isFavorite(String productId, {String? variantId}) {
    final key = variantId == null ? productId : '${productId}_$variantId';
    return items.any((i) => i.key == key);
  }

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<FavoriteItem>? items,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
