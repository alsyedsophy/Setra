import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';

class ProductColors extends StatefulWidget {
  const ProductColors({super.key, required this.colors, this.onColorSeleted});
  final List<String> colors;
  final ValueChanged<String>? onColorSeleted;
  @override
  State<ProductColors> createState() => _ProductColorsState();
}

class _ProductColorsState extends State<ProductColors> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Colors", style: context.textTheme.bodySmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(widget.colors.length, (index) {
            final isSelected = _selectedIndex == index;
            final colorsHex = widget.colors[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onColorSeleted?.call(widget.colors[index]);
                log(_selectedIndex.toString());
              },
              child: Container(
                margin: AppSpacing.w_10.mRight,
                padding: AppSpacing.h_4.pAll,
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
                child: ColorCircle(colorsHex: colorsHex),
              ),
            );
          }),
        ),
      ],
    ).paddingHorizontal(AppSpacing.w_16);
  }
}

class ColorCircle extends StatelessWidget {
  const ColorCircle({super.key, required this.colorsHex});

  final String colorsHex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.h_32,
      width: AppSpacing.h_32,
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
    } catch (e) {
      return Colors.grey; // لون احتياطي لو الكود غلط
    }
  }
}
