import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/home/presentation/cubit/home_cubit.dart';
import 'package:setra/features/home/presentation/cubit/home_state.dart';
import 'package:setra/features/home/presentation/widgets/category_banner.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            if (state.categories.isNotEmpty)
              CategoryBanner(category: state.categories.first),
            AppSpacing.h_12.hSpace,
            if (state.categories.length > 1)
              Row(
                children: [
                  for (int i = 1; i < state.categories.length && i <= 2; i++)
                    CategoryBanner(category: state.categories[i]).expanded,
                ],
              ),
          ],
        ).paddingHorizontal(AppSpacing.w_12);
      },
    );
  }
}
