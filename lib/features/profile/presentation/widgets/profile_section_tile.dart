import 'package:flutter/material.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';

class ProfileSectionTile extends StatelessWidget {
  const ProfileSectionTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: AppSpacing.h_20,
      margin: AppSpacing.h_10.mBottom,
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary,
        borderRadius: AppSpacing.r_12.rAll,
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Row(
        children: [
          Text(title, style: context.textTheme.bodyLarge),
          Spacer(),
          Icon(icon, size: AppSpacing.s_20),
          AppSpacing.w_20.wSpace,
          Icon(Icons.arrow_forward_ios, size: AppSpacing.s_25),
        ],
      ).paddingAll(AppSpacing.w_10),
    ).onTap(onTap);
  }
}
