import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/products/presentation/cubit/products_cubit.dart';
import 'package:setra/features/products/presentation/cubit/products_state.dart';
import 'package:setra/features/products/presentation/widgets/filter/custom_products_filter_sheet.dart';

class AppBarFilterWidget extends StatelessWidget {
  const AppBarFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      buildWhen: (p, c) => p.activeFilterCount != c.activeFilterCount,
      builder: (context, state) {
        return Stack(
          children: [
            IconButton(
              onPressed: () => _applyFilterSheet(context),
              icon: Icon(Icons.tune),
            ),
            if (state.activeFilterCount > 0)
              Positioned(
                top: AppSpacing.h_6,
                right: AppSpacing.w_4,
                child: Container(
                  padding: AppSpacing.h_4.pAll,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minHeight: AppSpacing.h_16,
                    minWidth: AppSpacing.w_16,
                  ),
                  child: Text(
                    '${state.activeFilterCount}',
                    style: context.textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _applyFilterSheet(BuildContext context) {
    final cubit = context.read<ProductsCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: CustomProductsFilterSheet()),
    );
  }
}
