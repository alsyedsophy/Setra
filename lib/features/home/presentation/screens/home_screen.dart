import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/components/app_loading.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/responsive/responsive_layout.dart';
import 'package:setra/core/widgets/custom_app_bar.dart';
import 'package:setra/features/home/presentation/cubit/home_cubit.dart';
import 'package:setra/features/home/presentation/cubit/home_state.dart';
import 'package:setra/features/home/presentation/widgets/banner_card.dart';
import 'package:setra/features/home/presentation/widgets/category_section.dart';
import 'package:setra/features/home/presentation/widgets/custom_home_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomHomeDrawer(),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.status == HomeStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: context.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == HomeStatus.loading) {
            return AppLoading();
          }

          return RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().loadHomeData(),
            child: ResponsiveLayout(
              mobile: _buildMobileLayout(context, state),
              // tablet: _buildTabletLayout(context, state),
              // desktop: _buildDesktopLayout(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, HomeState state) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BannerCard(banners: state.banners),
          CategorySection(),
          AppSpacing.h_50.hSpace,
        ],
      ),
    );
  }
}
