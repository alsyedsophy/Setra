import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/responsive/responsive_layout.dart';
import 'package:setra/core/widgets/custom_app_bar.dart';
import 'package:setra/features/home/domain/entities/product_entity.dart';
import 'package:setra/features/home/presentation/cubit/home_cubit.dart';
import 'package:setra/features/home/presentation/cubit/home_state.dart';
import 'package:setra/features/home/presentation/widgets/banner_card.dart';
import 'package:setra/features/home/presentation/widgets/category_section.dart';
import 'package:setra/features/home/presentation/widgets/product_section_category.dart';
import 'package:setra/features/home/presentation/widgets/title_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadProductsByGender(ProductGender.men);
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
            return const Center(child: CircularProgressIndicator());
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
          Center(
            child: Text(
              "Winter Collection",
              style: context.textTheme.headlineMedium,
            ),
          ),
          CategorySection(),
          TitleSection(title: 'New Arrivals', onTap: () {}),
          ProductSectionCategory(categoryName: "newArrival"),
          AppSpacing.h_12.hSpace,
          TitleSection(title: 'Featured', onTap: () {}),
          ProductSectionCategory(categoryName: "featured"),
          AppSpacing.h_50.hSpace,
        ],
      ),
    );
  }

  // Widget _buildTabletLayout(BuildContext context, HomeState state) {
  //   return SingleChildScrollView(
  //     physics: const AlwaysScrollableScrollPhysics(),
  //     child: Padding(
  //       padding: AppResponsive.padding(
  //         context,
  //         mobile: AppSpacing.p_16,
  //         tablet: AppSpacing.p_24,
  //         desktop: AppSpacing.p_32,
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const BannerCarousel(),
  //           AppSpacing.h_32.hSpace,
  //           CategoryList(categories: state.categories),
  //           AppSpacing.h_32.hSpace,
  //           SectionHeader(
  //             title: context.l10n.tr(L10nKeys.featuredProducts),
  //             onViewAll: () {},
  //           ),
  //           AppSpacing.h_16.hSpace,
  //           ProductGrid(products: state.featuredProducts, crossAxisCount: 3),
  //           AppSpacing.h_32.hSpace,
  //           SectionHeader(
  //             title: context.l10n.tr(L10nKeys.newArrivals),
  //             onViewAll: () {},
  //           ),
  //           AppSpacing.h_16.hSpace,
  //           ProductGrid(products: state.newArrivals, crossAxisCount: 3),
  //           AppSpacing.h_32.hSpace,
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDesktopLayout(BuildContext context, HomeState state) {
  //   return SingleChildScrollView(
  //     physics: const AlwaysScrollableScrollPhysics(),
  //     child: Padding(
  //       padding: AppResponsive.padding(
  //         context,
  //         mobile: AppSpacing.p_16,
  //         tablet: AppSpacing.p_24,
  //         desktop: AppSpacing.p_48,
  //       ),
  //       child: Center(
  //         child: ConstrainedBox(
  //           constraints: const BoxConstraints(maxWidth: 1200),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const BannerCarousel(),
  //               AppSpacing.h_48.hSpace,
  //               CategoryList(categories: state.categories),
  //               AppSpacing.h_48.hSpace,
  //               SectionHeader(
  //                 title: context.l10n.tr(L10nKeys.featuredProducts),
  //                 onViewAll: () {},
  //               ),
  //               AppSpacing.h_24.hSpace,
  //               ProductGrid(
  //                 products: state.featuredProducts,
  //                 crossAxisCount: 4,
  //               ),
  //               AppSpacing.h_48.hSpace,
  //               SectionHeader(
  //                 title: context.l10n.tr(L10nKeys.newArrivals),
  //                 onViewAll: () {},
  //               ),
  //               AppSpacing.h_24.hSpace,
  //               ProductGrid(products: state.newArrivals, crossAxisCount: 4),
  //               AppSpacing.h_48.hSpace,
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class CustomHomeDrawer extends StatelessWidget {
  const CustomHomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: context.colorScheme.primary,
      width: AppSpacing.w_256,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: AppSpacing.h_180,
            child: DrawerHeader(
              decoration: BoxDecoration(color: context.colorScheme.primary),

              child: Center(
                child: Text(
                  'Setra',
                  style: context.textTheme.headlineLarge!.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          CustomDrawerListTile(
            icon: Icons.home,
            title: 'Home',
            onTap: () => context.pop(),
          ),
          CustomDrawerListTile(icon: Icons.person, title: 'Mens'),
          CustomDrawerListTile(icon: Icons.person, title: 'Kids'),
          CustomDrawerListTile(
            icon: Icons.local_offer,
            title: 'Summer Collection',
          ),
          CustomDrawerListTile(
            icon: Icons.local_offer_sharp,
            title: 'Winter Collection',
          ),
          CustomDrawerListTile(icon: Icons.local_offer_sharp, title: 'Offers'),
          CustomDrawerListTile(icon: Icons.person, title: 'Profile'),
          CustomDrawerListTile(icon: Icons.logout, title: 'Logout'),
        ],
      ),
    );
  }
}

class CustomDrawerListTile extends StatelessWidget {
  const CustomDrawerListTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: context.colorScheme.primary),
      title: Text(title, style: context.textTheme.labelLarge),
      onTap: onTap,
    );
  }
}
