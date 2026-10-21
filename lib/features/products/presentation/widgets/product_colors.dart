import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/products/domain/entities/products_variant.dart';

class ProductColors extends StatelessWidget {
  const ProductColors({
    super.key,
    required this.variants,
    required this.selectedVariant,
    this.onVariantSelected,
  });
  final List<ProductsVariant> variants;
  final ProductsVariant selectedVariant;
  final ValueChanged<ProductsVariant>? onVariantSelected;
  @override
  Widget build(BuildContext context) {
    // 🎯 حجم الدائرة والمسافة بين الدوائر
    final double gap = context.responsive(
      mobile: AppSpacing.w_10,
      desktop: AppSpacing.w_12,
    );
    final double labelGap = context.responsive(
      mobile: AppSpacing.h_6,
      desktop: AppSpacing.h_8,
    );
    return Column(
      children: [
        Text("Colors", style: context.textTheme.bodySmall),
        labelGap.hSpace,
        Wrap(
          spacing: gap,
          runSpacing: gap,
          children: variants.map((variant) {
            final isSelected = selectedVariant.id == variant.id;
            return GestureDetector(
              onTap: () {
                onVariantSelected?.call(variant);
              },
              child: Container(
                padding: AppSpacing.h_4.pAll,
                margin: AppSpacing.w_10.mRight,
                decoration: BoxDecoration(
                  color: context.colorScheme.onPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? context.colorScheme.primary
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: ColorCircle(colorsHex: variant.color),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class ColorCircle extends StatelessWidget {
  const ColorCircle({super.key, required this.colorsHex});

  final String colorsHex;

  @override
  Widget build(BuildContext context) {
    final double size = context.responsive(
      mobile: AppSpacing.h_32,
      desktop: AppSpacing.h_40,
    );
    return Container(
      height: size,
      width: size,
      // padding: AppSpacing.r_4.pAll,
      decoration: BoxDecoration(
        color: _parseColor(colorsHex),
        shape: BoxShape.circle,
      ),
      // child: ,
    );
  }

  Color _parseColor(String hex) {
    try {
      String cleaned = hex.replaceAll('#', '');
      if (cleaned.length == 6) {
        cleaned = 'FF$cleaned'; // نضيف الشفافية
      }
      return Color(int.parse(cleaned, radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }
}
