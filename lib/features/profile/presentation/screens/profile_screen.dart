import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/components/app_loading.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/routing/routing.dart';
import 'package:setra/core/widgets/widgets.dart';

import 'package:setra/features/profile/domain/entities/profile_entity.dart';
import 'package:setra/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:setra/features/profile/presentation/cubit/profile_states.dart';
import 'package:setra/features/profile/presentation/widgets/logout_widget.dart';
import 'package:setra/features/profile/presentation/widgets/profile_image_avatar.dart';
import 'package:setra/features/profile/presentation/widgets/profile_section_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileCubit>().getProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              log("Can pop");
              context.pop();
            } else {
              context.goNamed(RoutePaths.homeName);
            }
          },
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.initial ||
              state.status == ProfileStatus.loading) {
            return AppLoading();
          }
          if (state.status == ProfileStatus.failure) {
            return AppErrorView(message: 'sdfg ${state.errorMessage!}');
          }
          if (state.status == ProfileStatus.loaded ||
              state.status == ProfileStatus.updating) {
            if (state.profile == null) {
              return AppEmptyView(
                message: 'Profile data is unavailable',
                icon: Icons.person_2_outlined,
              );
            }
            return _buildProfileContent(
              state.profile!,
              // isUpdating: state.status == ProfileStatus.updating,
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfileContent(ProfileEntity profile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileImageAvatar(photoUrl: profile.photoUrl),

          AppSpacing.h_20.hSpace,

          Text(
            profile.name,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          AppSpacing.h_8.hSpace,

          Text(
            profile.email ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          AppSpacing.h_36.hSpace,
          ProfileSectionTile(
            title: 'My Profile',
            icon: Icons.account_circle_outlined,
            onTap: () => context.pushNamed(
              RoutePaths.profileDetailsName,
              extra: profile,
            ),
          ),
          ProfileSectionTile(
            title: 'My Orders',
            icon: Icons.receipt_long_outlined,
            onTap: () => context.pushNamed(RoutePaths.ordersName),
          ),
          ProfileSectionTile(
            title: 'My Address',
            icon: Icons.place_outlined,
            onTap: () => context.pushNamed(RoutePaths.addressesName),
          ),
          ProfileSectionTile(
            title: 'My Favorites',
            icon: Icons.favorite_border_outlined,
            onTap: () => context.pushNamed(RoutePaths.favoritesName),
          ),
          ProfileSectionTile(title: 'Log out', icon: Icons.logout),

          AppSpacing.h_20.hSpace,
          Align(alignment: Alignment.center, child: LogoutWidget()),

          AppSpacing.h_30.hSpace,
        ],
      ).paddingHorizontal(AppSpacing.w_24),
    );
  }
}
