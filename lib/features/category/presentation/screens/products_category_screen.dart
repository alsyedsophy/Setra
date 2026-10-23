import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/components/app_loading.dart';
import 'package:setra/core/widgets/custom_app_bar.dart';
import 'package:setra/core/widgets/widgets.dart';
import 'package:setra/features/home/presentation/widgets/custom_home_drawer.dart';
import 'package:setra/features/products/presentation/cubit/products_cubit.dart';
import 'package:setra/features/products/presentation/cubit/products_state.dart';
import 'package:setra/features/products/presentation/screens/products_list_screen.dart';

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
          return RefreshIndicator(
            onRefresh: () => context.read<ProductsCubit>().refresh(),
            child: ProductsGrid(products: state.products),
          );
        },
      ),
    );
  }
}
