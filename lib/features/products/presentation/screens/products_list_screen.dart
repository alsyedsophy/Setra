import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/components/app_loading.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/widgets/app_empty_view.dart';
import 'package:setra/core/widgets/app_error_view.dart';
import 'package:setra/features/home/presentation/widgets/product_home_image.dart';
import 'package:setra/features/products/presentation/cubit/products_cubit.dart';
import 'package:setra/features/products/presentation/cubit/products_state.dart';
import 'package:setra/features/products/presentation/widgets/custom_products_filter_sheet.dart';
import 'package:setra/features/products/presentation/widgets/custom_products_sort_sheet.dart';

class ProductsListScreen extends StatelessWidget {
  const ProductsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"),
        actions: [
          IconButton(
            onPressed: () => _applySortSheet(context),
            icon: Icon(Icons.sort),
          ),
          AppBarFilterWidget(),
        ],
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state.status == ProductsStatus.loading &&
              state.products.isEmpty) {
            return AppLoading();
          }

          // Error
          if (state.status == ProductsStatus.failure &&
              state.products.isEmpty) {
            return AppErrorView(message: state.errorMessage!);
          }

          // Empty
          if (state.status == ProductsStatus.success &&
              state.products.isEmpty) {
            return AppEmptyView(message: "Not Products");
          }
          return RefreshIndicator(
            onRefresh: () => context.read<ProductsCubit>().refresh(),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.h_12,
                crossAxisSpacing: AppSpacing.w_12,
                childAspectRatio: 0.62,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ProductHomeImage(productEntity: product);
              },
            ).paddingHorizontalVertical(AppSpacing.w_12, AppSpacing.h_12),
          );
        },
      ),
    );
  }

  void _applySortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return CustomProductsSortSheet();
      },
    );
  }
}

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
