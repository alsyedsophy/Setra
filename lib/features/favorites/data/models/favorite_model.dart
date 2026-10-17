import 'package:setra/features/favorites/domain/entities/favorite_entity.dart';

class FavoriteItemModel extends FavoriteItem {
  const FavoriteItemModel({
    required super.productId,
    super.variantId,
    required super.name,
    required super.imageUrl,
    required super.price,
    required super.addedAt,
  });

  factory FavoriteItemModel.fromEntity(FavoriteItem e) => FavoriteItemModel(
        productId: e.productId,
        variantId: e.variantId,
        name: e.name,
        imageUrl: e.imageUrl,
        price: e.price,
        addedAt: e.addedAt,
      );

  factory FavoriteItemModel.fromMap(Map<dynamic, dynamic> m) =>
      FavoriteItemModel(
        productId: m['productId'] as String,
        variantId: m['variantId'] as String?,
        name: m['name'] as String,
        imageUrl: m['imageUrl'] as String,
        price: (m['price'] as num).toDouble(),
        addedAt: DateTime.fromMillisecondsSinceEpoch(m['addedAt'] as int),
      );

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'variantId': variantId,
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
        'addedAt': addedAt.millisecondsSinceEpoch,
      };

  // Firestore (addedAt as Timestamp)
  factory FavoriteItemModel.fromFirestore(Map<String, dynamic> m) =>
      FavoriteItemModel(
        productId: m['productId'] as String,
        variantId: m['variantId'] as String?,
        name: m['name'] as String,
        imageUrl: m['imageUrl'] as String,
        price: (m['price'] as num).toDouble(),
        addedAt: DateTime.parse(m['addedAt'] as String),
      );

  Map<String, dynamic> toFirestore() => {
        'productId': productId,
        'variantId': variantId,
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
        'addedAt': addedAt.toIso8601String(),
      };
}