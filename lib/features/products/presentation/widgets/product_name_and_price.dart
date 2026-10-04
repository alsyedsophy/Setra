import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';

class ProductNameAndPrice extends StatelessWidget {
  const ProductNameAndPrice({super.key, required this.productEntity});
  final ProductEntity productEntity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(productEntity.categoryId, style: context.textTheme.labelMedium),
        AppSpacing.h_4.hSpace,
        Text(productEntity.name, style: context.textTheme.headlineLarge),
        AppSpacing.h_4.hSpace,
        Text(
          "${productEntity.price} USA",
          style: context.textTheme.headlineMedium,
        ),
      ],
    ).paddingHorizontal(AppSpacing.w_16);
  }
}
