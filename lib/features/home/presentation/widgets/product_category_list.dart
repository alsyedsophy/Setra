import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/widgets/app_empty_view.dart';
import 'package:setra/core/widgets/app_error_view.dart';
import 'package:setra/features/home/presentation/widgets/product_home_image.dart';
import 'package:setra/features/products/domain/entities/product_filter.dart';
import 'package:setra/features/products/presentation/cubit/products_cubit.dart';
import 'package:setra/features/products/presentation/cubit/products_state.dart';

class ProductCategoryList extends StatefulWidget {
  const ProductCategoryList({super.key, required this.categoryId});
  final String categoryId;

  @override
  State<ProductCategoryList> createState() => _ProductCategoryListState();
}

class _ProductCategoryListState extends State<ProductCategoryList> {
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
        // if (state.status == ProductsStatus.initial ||
        //     state.status == ProductsStatus.loading) {
        //   return AppLoading();
        // }
        if (state.status == ProductsStatus.failure) {
          return AppErrorView(message: state.errorMessage!);
        }
        if (state.status == ProductsStatus.success && state.products.isEmpty) {
          return AppEmptyView(message: "No Products Now");
        }
        return SizedBox(
          height: AppSpacing.h_300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.products.length,
            itemBuilder: (context, index) => ProductHomeImage(
              productEntity: state.products[index],
            ).paddingHorizontal(AppSpacing.w_4),
          ),
        );
      },
    );
  }
}
