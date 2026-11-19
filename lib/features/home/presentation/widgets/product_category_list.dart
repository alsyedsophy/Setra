import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/dependency_injection/dependency_injection.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/widgets/app_empty_view.dart';
import 'package:setra/core/widgets/app_error_view.dart';
import 'package:setra/features/home/presentation/widgets/product_home_image.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/domain/entities/product_filter.dart';
import 'package:setra/features/products/presentation/cubit/products_cubit.dart';
import 'package:setra/features/products/presentation/cubit/products_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductCategoryList extends StatelessWidget {
  const ProductCategoryList({super.key, required this.categoryId});
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductsCubit>(),
      child: _ProductCategoryListView(categoryId: categoryId),
    );
  }
}

class _ProductCategoryListView extends StatefulWidget {
  const _ProductCategoryListView({required this.categoryId});

  final String categoryId;

  @override
  State<_ProductCategoryListView> createState() =>
      _ProductCategoryListViewState();
}

class _ProductCategoryListViewState extends State<_ProductCategoryListView> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().applyFilter(
      ProductFilter(categoryId: widget.categoryId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state.status == ProductsStatus.failure) {
          return AppErrorView(message: state.errorMessage!);
        }

        final isLoading =
            state.status == ProductsStatus.initial ||
            state.status == ProductsStatus.loading;

        if (!isLoading &&
            state.status == ProductsStatus.success &&
            state.products.isEmpty) {
          return AppEmptyView(message: "No Products Now");
        }

        final displayProducts = isLoading && state.products.isEmpty
            ? List.generate(8, (index) => ProductEntity.empty())
            : state.products;
        return SizedBox(
          height: AppSpacing.h_300,
          child: Skeletonizer(
            enabled: isLoading,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: displayProducts.length,
              itemBuilder: (context, index) => ProductHomeImage(
                productEntity: displayProducts[index],
              ).paddingHorizontal(AppSpacing.w_4),
            ),
          ),
        );
      },
    );
  }
}
