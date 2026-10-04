import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/routing/route_paths.dart';
import 'package:setra/core/widgets/app_network_image.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.productEntity});
  final ProductEntity productEntity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.h_433,
      width: AppSpacing.w_256,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: AppSpacing.r_12.rAll,
              child: AppNetworkImage(
                imageUrl: productEntity.mainImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          AppSpacing.h_10.hSpace,
          Text(
            productEntity.imageUrls.length.toString(),
            style: context.textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.h_4.hSpace,
          Row(
            children: [
              Text(
                '${productEntity.finalPrice.toStringAsFixed(2)} USD',
                style: context.textTheme.labelMedium?.copyWith(
                  color: productEntity.hasDiscount
                      ? context.colorScheme.error
                      : context.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (productEntity.hasDiscount) ...[
                AppSpacing.w_8.wSpace,
                Text(
                  '${productEntity.price.toStringAsFixed(2)} USD',
                  style: context.textTheme.labelSmall?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.w_8.wSpace,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.w_8,
                    vertical: AppSpacing.h_4,
                  ),
                  decoration: BoxDecoration(
                    color: context.colorScheme.error,
                    borderRadius: AppSpacing.r_4.rAll,
                  ),
                  child: Text(
                    '-${productEntity.discountPercentage}%',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onError,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    ).onTap(
      () => context.pushNamed(
        RoutePaths.productsDetailsName,
        extra: productEntity,
      ),
    );
  }
}
