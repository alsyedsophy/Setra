import 'package:flutter/material.dart';
import 'package:setra/core/extensions/context_extensions.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: context.textTheme.labelLarge);
  }
}
