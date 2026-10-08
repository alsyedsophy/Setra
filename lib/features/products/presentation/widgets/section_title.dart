import 'package:flutter/material.dart';
import 'package:setra/core/extensions/context_extensions.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: context.textTheme.titleLarge);
  }
}
