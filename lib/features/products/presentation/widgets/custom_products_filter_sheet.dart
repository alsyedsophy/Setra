import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/components/app_button.dart';
import 'package:setra/core/components/app_text_field.dart';
import 'package:setra/core/constants/product_filter_options.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/domain/entities/product_filter.dart';
import 'package:setra/features/products/presentation/cubit/products_cubit.dart';
import 'package:setra/features/products/presentation/cubit/products_state.dart';
import 'package:setra/features/products/presentation/widgets/custom_header_sheet.dart';
import 'package:setra/features/products/presentation/widgets/section_title.dart';

class CustomProductsFilterSheet extends StatefulWidget {
  const CustomProductsFilterSheet({super.key});

  @override
  State<CustomProductsFilterSheet> createState() =>
      _CustomProductsFilterSheetState();
}

class _CustomProductsFilterSheetState extends State<CustomProductsFilterSheet> {
  late ProductFilter _draft;
  late RangeValues _priceRange;
  late TextEditingController _brandController;

  @override
  void initState() {
    super.initState();
    _draft = context.read<ProductsCubit>().state.filter;
    _priceRange = RangeValues(
      _draft.minPrice ?? ProductFilterOptions.minPrice,
      _draft.maxPrice ?? ProductFilterOptions.maxPrice,
    );
    _brandController = TextEditingController(text: _draft.brand ?? "");
  }

  @override
  void dispose() {
    _brandController.dispose();
    super.dispose();
  }

  // =========== Helpers ===========

  bool get _isPriceRangeDefault =>
      _priceRange.start <= ProductFilterOptions.minPrice &&
      _priceRange.end >= ProductFilterOptions.maxPrice;

  void _toggleSize(String size) {
    final list = List<String>.from(_draft.sizes);
    list.contains(size) ? list.remove(size) : list.add(size);
    setState(() => _draft = _draft.copyWith(sizes: list));
  }

  void _toggleColor(String color) {
    final list = List<String>.from(_draft.colors);
    list.contains(color) ? list.remove(color) : list.add(color);
    setState(() => _draft = _draft.copyWith(colors: list));
  }

  void _toggleTag(String tag) {
    final list = List<String>.from(_draft.tags);
    list.contains(tag) ? list.remove(tag) : list.add(tag);
    setState(() => _draft = _draft.copyWith(tags: list));
  }

  void _setGender(ProductGender? gender) {
    setState(() {
      _draft = gender == null
          ? _draft.copyWith(clearGender: true)
          : _draft.copyWith(gender: gender);
    });
  }

  void _apply() {
    final finalFilter = _draft.copyWith(
      minPrice: _isPriceRangeDefault ? null : _priceRange.start,
      maxPrice: _isPriceRangeDefault ? null : _priceRange.end,
      brand: _brandController.text.trim().isEmpty
          ? null
          : _brandController.text,
      clearBrand: _brandController.text.trim().isEmpty,
    );
    context.read<ProductsCubit>().applyFilter(finalFilter);
    context.pop();
  }

  void _clearAll() {
    setState(() {
      _draft = ProductFilter();
      _priceRange = RangeValues(
        ProductFilterOptions.minPrice,
        ProductFilterOptions.maxPrice,
      );
      _brandController.clear();
    });
  }

  // =========== Build =========

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeaderSheet(title: 'Filters', onPressed: _clearAll),
            ListView(
              controller: scrollController,
              padding: AppSpacing.w_20.pH,
              children: [
                AppSpacing.h_8.hSpace,
                SectionTitle(title: "Gender"),
                AppSpacing.h_8.hSpace,
                _buildGenderChips(context),
                AppSpacing.h_24.hSpace,
                SectionTitle(title: "Price Range"),
                AppSpacing.h_4.hSpace,
                _buildPriceLabel(context),
                RangeSlider(
                  values: _priceRange,
                  min: ProductFilterOptions.minPrice,
                  max: ProductFilterOptions.maxPrice,
                  divisions: ProductFilterOptions.priceDivisions,
                  labels: RangeLabels(
                    '${_priceRange.start.round()}',
                    '${_priceRange.end.round()}',
                  ),
                  onChanged: (value) => setState(() {
                    _priceRange = value;
                    _draft = _draft.copyWith(
                      maxPrice: _isPriceRangeDefault ? null : value.end,
                      minPrice: _isPriceRangeDefault ? null : value.start,
                      clearPriceRange: _isPriceRangeDefault,
                    );
                  }),
                ),
                AppSpacing.h_16.hSpace,
                SectionTitle(title: "Quick Filters"),
                AppSpacing.h_4.hSpace,
                _buildSwitchTile(
                  context,
                  title: "On Sale",
                  value: _draft.hasDiscountOnly ?? false,
                  onChanged: (value) => setState(() {
                    _draft = value
                        ? _draft.copyWith(hasDiscountOnly: true)
                        : _draft.copyWith(clearHasDiscount: true);
                  }),
                ),
                _buildSwitchTile(
                  context,
                  title: "In Stock Only",
                  value: _draft.inStockOnly ?? false,
                  onChanged: (value) => setState(() {
                    _draft = value
                        ? _draft.copyWith(inStockOnly: true)
                        : _draft.copyWith(clearInStock: true);
                  }),
                ),
                _buildSwitchTile(
                  context,
                  title: 'Featured',
                  value: _draft.featuredOnly ?? false,
                  onChanged: (value) => setState(() {
                    _draft = value
                        ? _draft.copyWith(featuredOnly: true)
                        : _draft.copyWith(clearFeatured: true);
                  }),
                ),
                _buildSwitchTile(
                  context,
                  title: "New Arrivals",
                  value: _draft.newArrivalOnly ?? false,
                  onChanged: (value) => setState(() {
                    _draft = value
                        ? _draft.copyWith(newArrivalOnly: true)
                        : _draft.copyWith(clearNewArrival: true);
                  }),
                ),
                AppSpacing.h_24.hSpace,
                SectionTitle(title: "Sizes"),
                AppSpacing.h_8.hSpace,
                _buildStringChip(
                  context,
                  values: ProductFilterOptions.sizes,
                  selected: _draft.sizes,
                  onTap: _toggleSize,
                ),
                AppSpacing.h_24.hSpace,
                SectionTitle(title: "Colors"),
                AppSpacing.h_8.hSpace,
                _buildStringChip(
                  context,
                  values: ProductFilterOptions.colors,
                  selected: _draft.colors,
                  onTap: _toggleColor,
                ),
                AppSpacing.h_24.hSpace,
                SectionTitle(title: "Tags"),
                _buildStringChip(
                  context,
                  values: ProductFilterOptions.tags,
                  selected: _draft.tags,
                  onTap: _toggleTag,
                ),
                AppSpacing.h_24.hSpace,
                SectionTitle(title: 'Brand'),
                AppSpacing.h_8.hSpace,
                AppTextField(
                  controller: _brandController,
                  hint: 'e.g. Nike',
                  prefixIcon: Icons.business_outlined,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) => setState(() {
                    _draft = _draft.copyWith(
                      brand: value.trim().isEmpty ? null : value.trim(),
                      clearBrand: value.trim().isEmpty,
                    );
                  }),
                ),
                AppSpacing.h_32.hSpace,
              ],
            ).expanded,
            _buildBottomBar(context),
            AppSpacing.h_32.hSpace,
          ],
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      buildWhen: (p, c) => p.status != c.status,
      builder: (context, state) {
        final total = _draft.activeFilterCount;
        return AppButton(
          label: total > 0 ? 'Show Results ($total)' : 'Show Results',
          isLoading: state.status == ProductsStatus.loading,
          onPressed: _apply,
        ).paddingHorizontal(AppSpacing.w_20);
      },
    );
  }

  Widget _buildGenderChips(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: Text("All"),
          selected: _draft.gender == null,
          onSelected: (_) => _setGender(null),
        ),
        ChoiceChip(
          label: Text("Men"),
          selected: _draft.gender == ProductGender.men,
          onSelected: (_) => _setGender(ProductGender.men),
        ),
        ChoiceChip(
          label: Text('Kids'),
          selected: _draft.gender == ProductGender.kids,
          onSelected: (_) => _setGender(ProductGender.kids),
        ),
      ],
    );
  }

  Widget _buildPriceLabel(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${_priceRange.start.round()} EGP',
          style: context.textTheme.bodyMedium,
        ),
        Text(
          '${_priceRange.end.round()} EGP',
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title),
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  Widget _buildStringChip(
    BuildContext context, {
    required List<String> values,
    required List<String> selected,
    required ValueChanged<String> onTap,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: values.map((v) {
        final isSelected = selected.contains(v);
        return FilterChip(
          label: Text(v),
          selected: isSelected,
          onSelected: (_) => onTap(v),
        );
      }).toList(),
    );
  }
}
