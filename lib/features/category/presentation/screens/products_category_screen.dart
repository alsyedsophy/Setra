import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/widgets/custom_app_bar.dart';
import 'package:setra/core/widgets/widgets.dart';
import 'package:setra/features/home/presentation/widgets/custom_home_drawer.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/presentation/cubit/products_cubit.dart';
import 'package:setra/features/products/presentation/cubit/products_state.dart';
import 'package:setra/features/products/presentation/screens/all_collection_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({super.key, required this.categoryId});
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomHomeDrawer(),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          final isLoading =
              (state.status == ProductsStatus.initial ||
                  state.status == ProductsStatus.loading) &&
              state.products.isEmpty;
          if (state.status == ProductsStatus.failure) {
            return AppErrorView(message: state.errorMessage!);
          }
          if (state.status == ProductsStatus.success &&
              state.products.isEmpty) {
            return AppEmptyView(message: "No Products Now");
          }

          final List<ProductEntity> displayProducts =
              isLoading && state.products.isEmpty
              ? List.generate(8, (index) => ProductEntity.empty())
              : state.products;

          return RefreshIndicator(
            onRefresh: () => context.read<ProductsCubit>().refresh(),
            child: Skeletonizer(
              enabled: isLoading,
              child: ProductsGrid(products: displayProducts),
            ),
          );
        },
      ),
    );
  }
}
