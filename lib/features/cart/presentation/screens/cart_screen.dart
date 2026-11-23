import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/features/cart/domain/entities/cart_validation_result.dart';
import 'package:setra/features/cart/presentation/cubits/cart_cubit.dart';
import 'package:setra/features/cart/presentation/cubits/cart_state.dart';
import 'package:setra/features/cart/presentation/view/cart_body.dart';
import 'package:setra/features/home/presentation/widgets/custom_home_drawer.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _showValidationSnackBars(
    BuildContext context,
    List<CartItemChange> changes,
  ) {
    if (changes.isEmpty) return;

    final removed = changes
        .where(
          (c) =>
              c.type == CartItemChangeType.productRemoved ||
              c.type == CartItemChangeType.variantUnavailable,
        )
        .length;
    final qtyReduced = changes
        .where((c) => c.type == CartItemChangeType.quantityReduced)
        .length;
    final priceChanged = changes
        .where((c) => c.type == CartItemChangeType.priceChanged)
        .length;

    final parts = <String>[];
    if (removed > 0) {
      parts.add('تم إزالة $removed منتج غير متاح');
    }
    if (qtyReduced > 0) {
      parts.add('تم تعديل كمية $qtyReduced منتج');
    }
    if (priceChanged > 0) {
      parts.add('تم تحديث سعر $priceChanged منتج');
    }

    if (parts.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(parts.join(' • ')),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );

    context.read<CartCubit>().clearValidationChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart'), centerTitle: true),
      drawer: CustomHomeDrawer(),
      body: BlocConsumer<CartCubit, CartState>(
        listenWhen: (prev, curr) =>
            curr.validationChanges.isNotEmpty &&
            prev.validationChanges != curr.validationChanges,
        listener: (context, state) {
          _showValidationSnackBars(context, state.validationChanges);
        },
        builder: (context, state) => CartBody(state: state),
      ),
    );
  }
}
