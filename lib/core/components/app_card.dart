import 'package:flutter/material.dart';
import '../design_system/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.elevation = 4,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final Widget content = Padding(padding: padding, child: child);

    return Card(
      elevation: elevation,
      clipBehavior: onTap != null ? Clip.antiAlias : Clip.none,
      child: onTap != null ? InkWell(onTap: onTap, child: content) : content,
    );
  }
}
