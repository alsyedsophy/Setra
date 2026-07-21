import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/localization/l10n_extension.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(AppSpacing.h_40 + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        context.l10n.tr('appName'),
        style: context.textTheme.titleLarge,
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      toolbarHeight: AppSpacing.h_40,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(
          height: 1,
          color: context.colorScheme.primary,
          margin: EdgeInsets.zero,
        ),
      ),
    );
  }
}
