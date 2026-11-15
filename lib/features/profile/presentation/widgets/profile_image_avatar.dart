import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';

class ProfileImageAvatar extends StatelessWidget {
  const ProfileImageAvatar({super.key, required this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: AppSpacing.r_55,
      backgroundColor: context.colorScheme.onSecondary,
      backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
          ? NetworkImage(photoUrl!)
          : null,
      child: photoUrl == null || photoUrl!.isEmpty
          ? const Icon(Icons.person, size: 55, color: Colors.black)
          : null,
    );
  }
}
