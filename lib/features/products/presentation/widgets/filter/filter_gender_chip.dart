import 'package:flutter/material.dart';
import 'package:setra/features/products/domain/entities/product_entity.dart';
import 'package:setra/features/products/domain/entities/product_filter.dart';

class FilterGenderChip extends StatelessWidget {
  const FilterGenderChip({
    super.key,
    required this._draft,
    this.all,
    this.men,
    this.kids,
  });

  final ProductFilter _draft;
  final void Function(bool)? all;
  final void Function(bool)? men;
  final void Function(bool)? kids;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: Text("All"),
          selected: _draft.gender == null,
          onSelected: all,
        ),
        ChoiceChip(
          label: Text("Men"),
          selected: _draft.gender == ProductGender.men,
          onSelected: men,
        ),
        ChoiceChip(
          label: Text('Kids'),
          selected: _draft.gender == ProductGender.kids,
          onSelected: kids,
        ),
      ],
    );
  }
}
