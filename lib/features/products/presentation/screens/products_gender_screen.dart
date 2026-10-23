import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/components/app_loading.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/widgets/app_empty_view.dart';
import 'package:setra/core/widgets/app_error_view.dart';
import 'package:setra/core/widgets/custom_app_bar.dart';
import 'package:setra/features/category/domain/entities/category_entity.dart';
import 'package:setra/features/category/presentation/cubit/category_cubit.dart';
import 'package:setra/features/category/presentation/cubit/category_state.dart';
import 'package:setra/features/home/presentation/widgets/category_home_banner.dart';
import 'package:setra/features/home/presentation/widgets/custom_home_drawer.dart';

class ProductsGenderScreen extends StatefulWidget {
  const ProductsGenderScreen({super.key, required this.gender});
  final String gender;

  @override
  State<ProductsGenderScreen> createState() => _ProductsGenderScreenState();
}

class _ProductsGenderScreenState extends State<ProductsGenderScreen> {
  @override
  void initState() {
    super.initState();
    log("${widget.gender}====================================");
    context.read<CategoryCubit>().loadCategoriesForGender(widget.gender);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomHomeDrawer(),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          log(state.status.toString());
          if (state.status == CategoryStatus.initial ||
              state.status == CategoryStatus.loading) {
            return const AppLoading();
          }
          if (state.status == CategoryStatus.error) {
            return AppErrorView(message: state.errorMessage!);
          }
          if (state.status == CategoryStatus.loaded &&
              state.categories.isEmpty) {
            return const AppEmptyView(message: "No Products Now");
          }

          return _CategoryBanners(categories: state.categories);
        },
      ),
    );
  }
}

class _CategoryBanners extends StatelessWidget {
  const _CategoryBanners({required this.categories});

  final List<CategoryEntity> categories;

  @override
  Widget build(BuildContext context) {
    final int columns = context.responsive(mobile: 1, tablet: 2, desktop: 2);

    final double imageHeight = context.responsive(
      mobile: AppSpacing.h_248,
      tablet: AppSpacing.h_260,
      desktop: AppSpacing.h_300,
    );

    final double gap = context.responsive(
      mobile: AppSpacing.h_16,
      tablet: AppSpacing.h_20,
      desktop: AppSpacing.h_24,
    );

    final EdgeInsets outerPadding = EdgeInsets.symmetric(
      horizontal: context.responsive(
        mobile: AppSpacing.w_16,
        tablet: AppSpacing.w_24,
        desktop: AppSpacing.w_32,
      ),
      vertical: gap,
    );

    final double maxWidth = context.responsive(
      mobile: double.infinity,
      tablet: 1000,
      desktop: 1200,
    );

    if (columns == 1) {
      return SingleChildScrollView(
        padding: outerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final category in categories)
              Padding(
                padding: EdgeInsets.only(bottom: gap),
                child: CategoryHomeBanner(
                  category: category,
                  height: imageHeight,
                ),
              ),
          ],
        ),
      );
    }

    //  تابلت/ديسكتوب: شبكة بارتفاع ثابت
    // نضيف هامش تقديري لارتفاع العنوان (اسم القسم + المسافة)
    final double tileHeight = imageHeight + AppSpacing.h_4 + 32;

    final Widget grid = GridView.builder(
      padding: outerPadding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: gap,
        crossAxisSpacing: gap,
        mainAxisExtent: tileHeight,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoryHomeBanner(
          category: categories[index],
          height: imageHeight,
        );
      },
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: grid,
      ),
    );
  }
}
