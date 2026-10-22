import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/presentation/widgets/cart_item_card_view.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/domain/entities/products_variant.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({super.key, required this.item, this.product});

  final CartItemEntity item;
  final ProductEntity? product;

  int _getAvailableStock() {
    log(product.toString());
    if (product == null || product!.variants.isEmpty) {
      return item.quantity;
    }

    ProductsVariant? variant;
    try {
      variant = product!.variants.firstWhere((v) => v.id == item.variantId);
    } catch (_) {
      try {
        variant = product!.variants.firstWhere((v) => v.color == item.color);
      } catch (_) {
        variant = product!.variants.first;
      }
    }
    log('Variant in card is :  $variant ==================');

    if (variant.sizes.isEmpty) return 0;

    VariantSize? size;
    try {
      size = variant.sizes.firstWhere((s) => s.size == item.size);
    } catch (_) {
      size = variant.sizes.first;
    }

    log('Size in CArd is $size ====================');

    if (!size.isActive) return 0;
    return size.stock;
  }

  @override
  Widget build(BuildContext context) {
    final currentStock = _getAvailableStock();
    log('current stock in card is : $currentStock');
    return CartItemCardView(
      item: item,
      currentStock: currentStock,
      productName: product?.name,
      brand: product?.brand,
    );
  }
}
