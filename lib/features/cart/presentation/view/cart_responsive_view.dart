import 'package:flutter/widgets.dart';
import 'package:setra/core/responsive/responsive_layout.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/presentation/view/cart_split_layout.dart';
import 'package:setra/features/cart/presentation/view/cart_stacked_layout.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';

class CartResponsiveView extends StatelessWidget {
  const CartResponsiveView({
    required this.cart,
    required this.productsById,
    super.key,
  });

  final CartEntity cart;
  final Map<String, ProductEntity?> productsById;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: CartStackedLayout(cart: cart, productsById: productsById),
      tablet: CartStackedLayout(cart: cart, productsById: productsById),
      desktop: CartSplitLayout(cart: cart, productsById: productsById),
    );
  }
}
