import 'package:flutter/material.dart';
import 'package:setra/core/constants/product_filter_options.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/products/domain/entities/product_filter.dart';
import 'package:setra/features/products/presentation/widgets/filter_string_chip.dart';
import 'package:setra/features/products/presentation/widgets/section_title.dart';

class FilterCustomStringAllChips extends StatelessWidget {
  const FilterCustomStringAllChips({
    super.key,
    required this._draft,
    required this.toggleSize,
    required this.toggleColor,
    required this.toggleTag,
  });

  final ProductFilter _draft;
  final void Function(String) toggleSize;
  final void Function(String) toggleColor;
  final void Function(String) toggleTag;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(title: "Sizes"),
        AppSpacing.h_8.hSpace,
        FilterStringChip(
          values: ProductFilterOptions.sizes,
          selected: _draft.sizes,
          onTap: toggleSize,
        ),
        AppSpacing.h_24.hSpace,
        SectionTitle(title: "Colors"),
        AppSpacing.h_8.hSpace,
        FilterStringChip(
          values: ProductFilterOptions.colors,
          selected: _draft.colors,
          onTap: toggleColor,
        ),
        AppSpacing.h_24.hSpace,
        SectionTitle(title: "Tags"),
        FilterStringChip(
          values: ProductFilterOptions.tags,
          selected: _draft.tags,
          onTap: toggleTag,
        ),
        AppSpacing.h_24.hSpace,
      ],
    );
  }
}
