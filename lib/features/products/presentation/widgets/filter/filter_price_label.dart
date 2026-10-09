import 'package:flutter/material.dart';
import 'package:setra/core/extensions/context_extensions.dart';

class FilterPriceLabel extends StatelessWidget {
  const FilterPriceLabel({super.key, required this.priceRange});

  final RangeValues priceRange;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${priceRange.start.round()} EGP',
          style: context.textTheme.bodyMedium,
        ),
        Text(
          '${priceRange.end.round()} EGP',
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
