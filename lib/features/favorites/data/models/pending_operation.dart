import 'package:setra/features/favorites/data/models/favorite_model.dart';

enum PendingOpType { add, remove }

class PendingOperation {
  final String productId;
  final String? variantId;
  final PendingOpType type;
  final FavoriteItemModel? item; // only populated for 'add' operations
  final DateTime createdAt;

  PendingOperation({
    required this.productId,
    this.variantId,
    required this.type,
    this.item,
    required this.createdAt,
  });

  String get key => variantId == null ? productId : '${productId}_$variantId';

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'variantId': variantId,
    'type': type.name,
    'item': item?.toMap(),
    'createdAt': createdAt.millisecondsSinceEpoch,
  };

  factory PendingOperation.fromMap(Map<String, dynamic> map) =>
      PendingOperation(
        productId: map['productId'] as String,
        variantId: map['variantId'] as String?,
        type: PendingOpType.values.byName(map['type'] as String),
        item: map['item'] == null
            ? null
            : FavoriteItemModel.fromMap(Map.from(map['item'] as Map)),
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      );
}