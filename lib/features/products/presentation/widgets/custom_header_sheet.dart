import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/extensions/widget_extensions.dart';

class CustomHeaderSheet extends StatelessWidget {
  const CustomHeaderSheet({
    super.key,
    this.onPressed,
    required this.title,
    this.bottomTitle,
  });

  final String title;
  final String? bottomTitle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSpacing.h_8.hSpace,
        Container(
          height: AppSpacing.h_4,
          width: AppSpacing.w_40,
          decoration: BoxDecoration(
            color: context.colorScheme.onPrimaryContainer,
            borderRadius: AppSpacing.r_2.rAll,
          ),
        ),
        Row(
          children: [
            Text(title, style: context.textTheme.titleLarge),
            Spacer(),
            TextButton(
              onPressed: onPressed,
              child: Text(bottomTitle ?? "Clear all"),
            ),
          ],
        ).paddingFromLTRP(
          AppSpacing.w_20,
          AppSpacing.h_12,
          AppSpacing.w_8,
          AppSpacing.h_12,
        ),
        Divider(height: 1),
      ],
    );
  }
}
