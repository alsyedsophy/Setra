import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/home/presentation/widgets/product_card.dart';

class ProductSectionCategory extends StatelessWidget {
  const ProductSectionCategory({
    super.key,
    required this.categoryName,
    required this.products,
  });
  final String categoryName;
  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: AppSpacing.h_381,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.w_10),
        itemCount: products.length,
        itemBuilder: (context, index) => ProductCard(
          productEntity: products[index],
        ).paddingHorizontal(AppSpacing.w_4),
      ),
    );
  }
}
