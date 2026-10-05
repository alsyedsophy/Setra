import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/features/home/presentation/cubit/home_cubit.dart';
import 'package:setra/features/home/presentation/cubit/home_state.dart';
import 'package:setra/features/home/presentation/widgets/category_banner.dart';
import 'package:setra/features/home/presentation/widgets/product_category_list.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.categories.length,
          itemBuilder: (context, index) {
            log(state.categories.length.toString());
            final category = state.categories[index];
            return Column(
              children: [
                CategoryBanner(category: category),
                ProductCategoryList(
                  products: state.products,
                  categoryId: category.id,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
