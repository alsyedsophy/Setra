import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';

class ProductSize extends StatefulWidget {
  const ProductSize({super.key, required this.sizes, this.onSelectedSize});
  final List<String> sizes;
  final ValueChanged<String>? onSelectedSize;

  @override
  State<ProductSize> createState() => _ProductSizeState();
}

class _ProductSizeState extends State<ProductSize> {
  int _selectedIndex = 0;
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
          children: List.generate(widget.sizes.length, (index) {
            final size = widget.sizes[index];
            final isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onSelectedSize?.call(widget.sizes[index]);
              },
              child: Container(
                margin: AppSpacing.w_10.pRight,
                height: buttonHeight,
                width: buttonWidth,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
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
                  size,
                  style: context.textTheme.bodySmall!.copyWith(
                    color: isSelected ? context.colorScheme.onPrimary : null,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
