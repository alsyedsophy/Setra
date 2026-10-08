import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/extensions/widget_extensions.dart';
import 'package:setra/features/products/domain/entities/product_sort.dart';
import 'package:setra/features/products/presentation/cubit/products_cubit.dart';
import 'package:setra/features/products/presentation/cubit/products_state.dart';
import 'package:setra/features/products/presentation/widgets/custom_header_sheet.dart';

class CustomProductsSortSheet extends StatelessWidget {
  const CustomProductsSortSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      buildWhen: (previous, current) => previous.sort != current.sort,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: AppSpacing.h_20.rTop,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSpacing.h_8.hSpace,
              CustomHeaderSheet(
                title: 'Sort by',
                bottomTitle: 'Close',
                onPressed: context.pop,
              ),
              ListView(
                shrinkWrap: true,
                padding: AppSpacing.h_8.pV,
                children: ProductSortOption.values.map((option) {
                  final isSelected = state.sort.option == option;
                  return Material(
                    type: MaterialType.transparency,
                    child: RadioListTile<ProductSortOption>(
                      value: option,
                      groupValue: state.sort.option,
                      onChanged: (value) {
                        if (value != null && value != state.sort.option) {
                          context.read<ProductsCubit>().applySort(
                            ProductSort(option: option),
                          );
                        }
                        context.pop();
                      },
                      title: Text(
                        _label(option),
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      activeColor: context.colorScheme.primary,
                    ),
                  );
                }).toList(),
              ).flexible,
              AppSpacing.h_12.hSpace,
            ],
          ),
        );
      },
    );
  }

  /// تسميات مقروءة لكل خيار ترتيب
  String _label(ProductSortOption option) {
    switch (option) {
      case ProductSortOption.newest:
        return 'Newest';
      case ProductSortOption.priceLowToHigh:
        return 'Price: Low to High';
      case ProductSortOption.priceHighToLow:
        return 'Price: High to Low';
      case ProductSortOption.highestRated:
        return 'Highest Rated';
      case ProductSortOption.mostReviewed:
        return 'Most Reviewed';
      case ProductSortOption.bestDiscount:
        return 'Best Discount';
      case ProductSortOption.featured:
        return 'Featured First';
      case ProductSortOption.nameAsc:
        return 'Name: A → Z';
      case ProductSortOption.nameDesc:
        return 'Name: Z → A';
    }
  }
}
