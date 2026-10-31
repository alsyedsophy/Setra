import 'package:flutter/material.dart';
import 'package:setra/core/extensions/widget_extensions.dart';

class SummaryRow extends StatelessWidget {
  final String title;
  final double value;
  final bool isTotal;

  const SummaryRow({
    super.key,
    required this.title,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ).expanded,
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
