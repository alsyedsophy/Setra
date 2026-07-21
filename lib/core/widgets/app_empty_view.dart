import 'package:flutter/material.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';

import '../design_system/design_system.dart';

/// Full-screen empty state.
///
/// The [message] is supplied by the caller and is expected to be localized.
class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    required this.message,
    this.icon = Icons.inbox_outlined,
    super.key,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            size: AppSpacing.s_30,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          AppSpacing.h_24.hSpace,
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ).paddingAll(AppSpacing.h_48),
    );
  }
}
