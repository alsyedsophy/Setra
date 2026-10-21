import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';

class ProductQuantity extends StatefulWidget {
  const ProductQuantity({
    super.key,
    required this.initialQuantity,
    required this.onChange,
    required this.variantStock,
  });
  final int variantStock;
  final int initialQuantity;
  final void Function(int quantity) onChange;

  @override
  State<ProductQuantity> createState() => _ProductQuantityState();
}

class _ProductQuantityState extends State<ProductQuantity> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Quantity:', style: context.textTheme.bodyMedium),
        Spacer(),
        Row(
          children: [
            Container(
              width: AppSpacing.w_24,
              height: AppSpacing.h_24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: AppSpacing.r_2.rAll,
                border: Border.all(
                  color: context.colorScheme.primary,
                  width: 0.5,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  if (quantity > 1) {
                    setState(() {
                      quantity--;
                    });
                    widget.onChange(quantity);
                  }
                },
                child: const Icon(Icons.remove, size: 16),
              ),
            ),
            AppSpacing.w_10.wSpace,
            Text(quantity.toString(), style: context.textTheme.titleMedium),
            AppSpacing.w_10.wSpace,
            Container(
              width: AppSpacing.w_24,
              height: AppSpacing.h_24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: AppSpacing.r_2.rAll,
                border: Border.all(
                  color: context.colorScheme.primary,
                  width: 0.5,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  if (quantity < widget.variantStock) {
                    setState(() {
                      quantity++;
                    });
                    widget.onChange(quantity);
                  }
                },
                child: const Icon(Icons.add, size: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
