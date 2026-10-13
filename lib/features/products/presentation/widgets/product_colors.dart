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
          children: List.generate(widget.colors.length, (index) {
            final isSelected = _selectedIndex == index;
            final colorsHex = widget.colors[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onColorSeleted?.call(widget.colors[index]);
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
