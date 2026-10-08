import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/components/app_loading.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/widgets/app_empty_view.dart';
import 'package:setra/core/widgets/app_error_view.dart';
import 'package:setra/core/widgets/custom_app_bar.dart';
import 'package:setra/features/category/presentation/cubit/category_cubit.dart';
import 'package:setra/features/category/presentation/cubit/category_state.dart';
import 'package:setra/features/home/presentation/widgets/category_home_banner.dart';
import 'package:setra/features/home/presentation/widgets/custom_home_drawer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.gender});
  final String gender;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().loadCategoriesForGender(widget.gender);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomHomeDrawer(),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state.status == CategoryStatus.initial ||
              state.status == CategoryStatus.loading) {
            return AppLoading();
          }
          if (state.status == CategoryStatus.error) {
            return AppErrorView(message: state.errorMessage!);
          }
          if (state.status == CategoryStatus.loaded &&
              state.categories.isEmpty) {
            return AppEmptyView(message: "No Products Now");
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(state.categories.length, (index) {
                final category = state.categories[index];
                return CategoryHomeBanner(category: category);
              }),
            ).paddingHorizontal(AppSpacing.w_16),
          );
        },
      ),
    );
  }
}
