import 'package:flutter/material.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import '../design_system/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.padding,
    this.elevation = 4,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry effectivePadding = padding ?? AppSpacing.h_24.pAll;
    final Widget content = Padding(padding: effectivePadding, child: child);

    return Card(
      elevation: elevation,
      clipBehavior: onTap != null ? Clip.antiAlias : Clip.none,
      child: onTap != null ? InkWell(onTap: onTap, child: content) : content,
    );
  }
}
