import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/components/app_loading.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/responsive/responsive.dart';
import 'package:setra/core/widgets/app_empty_view.dart';
import 'package:setra/core/widgets/app_error_view.dart';
import 'package:setra/features/home/presentation/widgets/custom_home_drawer.dart';
import 'package:setra/features/home/presentation/widgets/product_home_image.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/presentation/cubit/products_cubit.dart';
import 'package:setra/features/products/presentation/cubit/products_state.dart';
import 'package:setra/features/products/presentation/widgets/app_bar_filter_widget.dart';
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
            icon: const Icon(Icons.sort),
          ),
          const AppBarFilterWidget(),
        ],
      ),
      drawer: CustomHomeDrawer(),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state.status == ProductsStatus.loading &&
              state.products.isEmpty) {
            return const AppLoading();
          }

          if (state.status == ProductsStatus.failure &&
              state.products.isEmpty) {
            return AppErrorView(message: state.errorMessage!);
          }

          if (state.status == ProductsStatus.success &&
              state.products.isEmpty) {
            return const AppEmptyView(message: "Not Products");
          }

          return RefreshIndicator(
            onRefresh: () => context.read<ProductsCubit>().refresh(),
            child: ProductsGrid(products: state.products),
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
      builder: (_) => const CustomProductsSortSheet(),
    );
  }
}

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({super.key, required this.products});

  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    //  عدد الأعمدة — القيمة الأساسية المتجاوبة
    final int columns = AppResponsive.gridColumnsFor(context.breakpoint);

    //  المسافات
    final EdgeInsets outerPadding = EdgeInsets.symmetric(
      horizontal: context.responsive(
        mobile: AppSpacing.w_12,
        tablet: AppSpacing.w_20,
        desktop: AppSpacing.w_24,
      ),
      vertical: context.responsive(
        mobile: AppSpacing.h_12,
        tablet: AppSpacing.h_20,
        desktop: AppSpacing.h_24,
      ),
    );

    final double crossSpacing = context.responsive(
      mobile: AppSpacing.w_12,
      tablet: AppSpacing.w_16,
      desktop: AppSpacing.w_20,
    );
    final double mainSpacing = context.responsive(
      mobile: AppSpacing.h_12,
      tablet: AppSpacing.h_16,
      desktop: AppSpacing.h_20,
    );

    final double aspectRatio = context.responsive(
      mobile: 0.62,
      tablet: 0.68,
      desktop: 0.72,
    );

    final double maxContentWidth = context.responsive(
      mobile: double.infinity,
      tablet: 1000,
      desktop: 1400,
    );

    final Widget grid = GridView.builder(
      padding: outerPadding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: mainSpacing,
        crossAxisSpacing: crossSpacing,
        childAspectRatio: aspectRatio,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductHomeImage(productEntity: products[index]);
      },
    );

    if (maxContentWidth == double.infinity) return grid;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: grid,
      ),
    );
  }
}
