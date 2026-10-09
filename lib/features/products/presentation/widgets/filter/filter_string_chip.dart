import 'package:flutter/material.dart';

class FilterStringChip extends StatelessWidget {
  const FilterStringChip({
    super.key,
    required this.values,
    required this.selected,
    required this.onTap,
  });

  final List<String> values;
  final List<String> selected;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: values.map((v) {
        final isSelected = selected.contains(v);
        return FilterChip(
          label: Text(v),
          selected: isSelected,
          onSelected: (_) => onTap(v),
        );
      }).toList(),
    );
  }
}
