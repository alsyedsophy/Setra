import 'package:flutter/material.dart';
import 'package:setra/core/extensions/context_extensions.dart';

import '../design_system/app_spacing.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({this.label, super.key});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(color: theme.colorScheme.primary),
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(label!, style: theme.textTheme.bodyMedium),
            ),
        ],
      ),
    );
  }
}
