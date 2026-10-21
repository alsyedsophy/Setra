import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/products/domain/entities/products_variant.dart';

class ProductSize extends StatelessWidget {
  const ProductSize({
    super.key,
    required this.sizes,
    this.selectedSize,
    this.onSelectedSize,
  });
  final List<VariantSize> sizes;
  final VariantSize? selectedSize;
  final ValueChanged<VariantSize>? onSelectedSize;

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = context.responsive(
      mobile: AppSpacing.w_56,
      desktop: AppSpacing.w_64,
    );
    final double buttonHeight = context.responsive(
      mobile: AppSpacing.h_40,
      desktop: AppSpacing.h_48,
    );
    final double gap = context.responsive(
      mobile: AppSpacing.w_10,
      desktop: AppSpacing.w_12,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Size", style: context.textTheme.labelMedium),
        AppSpacing.h_6.hSpace,
        Wrap(
          spacing: gap,
          runSpacing: gap,
          children: sizes.map((size) {
            final isEnable = size.isActive && size.stock > 0;
            final isSelected =
                selectedSize != null && size.id == selectedSize!.id;
            return GestureDetector(
              onTap: isEnable ? () => onSelectedSize?.call(size) : null,
              child: Opacity(
                opacity: isEnable ? 1 : 0.35,
                child: Container(
                  margin: AppSpacing.w_10.pRight,
                  height: buttonHeight,
                  width: buttonWidth,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected && isEnable
                        ? context.colorScheme.primary
                        : Colors.transparent,
                    shape: BoxShape.rectangle,
                    borderRadius: AppSpacing.r_2.rAll,
                    border: Border.all(
                      color: context.colorScheme.primary,
                      width: 0.6,
                    ),
                  ),
                  child: Text(
                    size.size,
                    style: context.textTheme.bodySmall!.copyWith(
                      color: isSelected && isEnable
                          ? context.colorScheme.onPrimary
                          : null,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
