import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/products/domain/entities/product_filter.dart';
import 'package:setra/features/products/presentation/widgets/filter_switch_tile.dart';
import 'package:setra/features/products/presentation/widgets/section_title.dart';

class FilterCustomAllSwitchTitle extends StatelessWidget {
  const FilterCustomAllSwitchTitle({
    super.key,
    required this.draft,
    required this.toggleSale,
    required this.toggleStock,
    required this.toggleNewArravile,
    required this.toggleFeatured,
  });

  final ProductFilter draft;
  final void Function(bool) toggleSale;
  final void Function(bool) toggleStock;
  final void Function(bool) toggleNewArravile;
  final void Function(bool) toggleFeatured;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(title: "Quick Filters"),
        AppSpacing.h_4.hSpace,
        FilterSwitchTile(
          title: "On Sale",
          value: draft.hasDiscountOnly ?? false,
          onChanged: toggleSale,
        ),
        FilterSwitchTile(
          title: "In Stock Only",
          value: draft.inStockOnly ?? false,
          onChanged: toggleStock,
        ),
        FilterSwitchTile(
          title: 'Featured',
          value: draft.featuredOnly ?? false,
          onChanged: toggleFeatured,
        ),
        FilterSwitchTile(
          title: "New Arrivals",
          value: draft.newArrivalOnly ?? false,
          onChanged: toggleNewArravile,
        ),
        AppSpacing.h_24.hSpace,
      ],
    );
  }
}
