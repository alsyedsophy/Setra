import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/features/category/presentation/cubit/category_cubit.dart';
import 'package:setra/features/category/presentation/cubit/category_state.dart';
import 'package:setra/features/home/presentation/widgets/category_home_banner.dart';
import 'package:setra/features/home/presentation/widgets/product_category_list.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
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
                CategoryHomeBanner(category: category),
                ProductCategoryList(categoryId: category.id),
              ],
            );
          },
        );
      },
    );
  }
}
