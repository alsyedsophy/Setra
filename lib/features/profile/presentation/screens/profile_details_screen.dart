import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/components/app_button.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/extensions/widget_extensions.dart';
import 'package:setra/core/routing/route_paths.dart';
import 'package:setra/features/profile/domain/entities/profile_entity.dart';
import 'package:setra/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:setra/features/profile/presentation/cubit/profile_states.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key, required this.profile});
  final ProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Details'), centerTitle: true),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final currentProfile = state.profile ?? profile;
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: AppSpacing.h_722),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileSectionTitle(title: 'Personal Information'),

                  AppSpacing.h_16.hSpace,

                  ProfileInfoTile(
                    icon: Icons.person_outline,
                    title: 'Full Name',
                    value: currentProfile.name,
                  ),

                  ProfileInfoTile(
                    icon: Icons.email_outlined,
                    title: 'Email Address',
                    value: currentProfile.email ?? 'Not provided',
                  ),

                  ProfileInfoTile(
                    icon: Icons.phone_outlined,
                    title: 'Phone Number',
                    value: currentProfile.phoneNumber ?? 'Not provided',
                  ),

                  AppSpacing.h_30.hSpace,

                  AppButton(
                    label: 'Edit Profile',
                    onPressed: () => context.pushNamed(
                      RoutePaths.profileUpdateName,
                      extra: profile,
                    ),
                    // isLoading: ,
                  ),
                ],
              ).paddingHorizontalVertical(AppSpacing.w_20, AppSpacing.h_24),
            ),
          );
        },
      ),
    );
  }
}

class ProfileInfoTile extends StatelessWidget {
  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: AppSpacing.h_12.mBottom,
      padding: AppSpacing.w_12.pAll,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppSpacing.r_12.rAll,
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: AppSpacing.s_25),
          AppSpacing.w_12.wSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ).expanded,
        ],
      ),
    );
  }
}

class ProfileSectionTitle extends StatelessWidget {
  const ProfileSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        title,
        style: context.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
