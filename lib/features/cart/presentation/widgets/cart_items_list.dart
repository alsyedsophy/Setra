import 'package:flutter/material.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';

class CartItemsList extends StatelessWidget {
  const CartItemsList({
    required this.cart,
    required this.productsById,
    super.key,
  });

  final CartEntity cart;
  final Map<String, ProductEntity?> productsById;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        final item = cart.items[index];
        return CartItemCard(item: item, product: productsById[item.productId]);
      },
    );
  }
}
