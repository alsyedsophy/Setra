import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/num_extensions.dart';

class EmptyAddress extends StatelessWidget {
  final VoidCallback onSelect;

  const EmptyAddress({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('No shipping address selected.'),
        AppSpacing.h_8.hSpace,
        OutlinedButton(
          onPressed: onSelect,
          child: const Text('Select Address'),
        ),
      ],
    );
  }
}
