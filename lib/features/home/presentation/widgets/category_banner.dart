import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/widgets/app_network_image.dart';
import 'package:setra/features/home/domain/entities/category_entity.dart';

class CategoryBanner extends StatelessWidget {
  const CategoryBanner({
    super.key,
    required this.category,
    this.height,
  });
  final CategoryEntity category;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppSpacing.r_12.rAll,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(
            imageUrl: category.imageUrl,
            fit: BoxFit.cover,
            height: height ?? AppSpacing.h_248,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: AppSpacing.h_20,
            right: AppSpacing.w_16,
            left: AppSpacing.w_16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  category.name.toUpperCase(),
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.h_4.hSpace,
                Text(
                  '${category.productCount} Products',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onPrimary.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).paddingHorizontal(AppSpacing.w_12);
  }
}