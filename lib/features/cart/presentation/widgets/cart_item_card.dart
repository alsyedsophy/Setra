import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/features/cart/domain/entities/cart_entity.dart';
import 'package:setra/features/cart/presentation/widgets/cart_item_card_view.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/presentation/cubit/products_cubit.dart';
import 'package:setra/features/products/presentation/cubit/products_state.dart';

class CartItemCard extends StatefulWidget {
  const CartItemCard({super.key, required this.item});

  final CartItemEntity item;

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  @override
  void initState() {
    context.read<ProductsCubit>().getProductById(widget.item.productId);
    super.initState();
  }

  int _getAvilableStock(ProductEntity? prouct) {
    final variant = prouct?.variants.firstWhere(
      (varaint) => varaint.color == widget.item.color,
      orElse: () => prouct.variants.first,
    );

    final size = variant?.sizes.firstWhere(
      (size) => size.size == widget.item.size,
      orElse: () => variant.sizes.first,
    );

    return size?.stock ?? widget.item.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        final ProductEntity? product = state.productById;
        final currentStock = _getAvilableStock(product);
        return CartItemCardView(item: widget.item, currentStock: currentStock);
      },
    );
  }
}
