import 'package:equatable/equatable.dart';

class FavoriteItem extends Equatable {
  final String productId;
  final String? variantId;
  final String name;
  final String imageUrl;
  final double price;
  final DateTime addedAt;

  const FavoriteItem({
    required this.productId,
    this.variantId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.addedAt,
  });

  /// Unique key for deduplication
  String get key => variantId == null ? productId : '${productId}_$variantId';

  @override
  List<Object?> get props => [productId, variantId, name, price, addedAt];
}
