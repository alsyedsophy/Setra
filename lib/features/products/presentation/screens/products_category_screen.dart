import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/components/app_loading.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/widget_extensions.dart';
import 'package:setra/core/widgets/custom_app_bar.dart';
import 'package:setra/core/widgets/widgets.dart';
import 'package:setra/features/home/presentation/widgets/custom_home_drawer.dart';
import 'package:setra/features/home/presentation/widgets/product_home_image.dart';
import 'package:setra/features/products/presentation/cubit/products_cubit.dart';
import 'package:setra/features/products/presentation/cubit/products_state.dart';

class ProductsCategoryScreen extends StatelessWidget {
  const ProductsCategoryScreen({super.key, required this.categoryId});
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomHomeDrawer(),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state.status == ProductsStatus.initial ||
              state.status == ProductsStatus.loading) {
            return AppLoading();
          }
          if (state.status == ProductsStatus.failure) {
            return AppErrorView(message: state.errorMessage!);
          }
          if (state.status == ProductsStatus.success &&
              state.products.isEmpty) {
            return AppEmptyView(message: "No Products Now");
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: .46,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return ProductHomeImage(productEntity: product);
            },
          ).paddingHorizontal(AppSpacing.w_8);
        },
      ),
    );
  }
}
