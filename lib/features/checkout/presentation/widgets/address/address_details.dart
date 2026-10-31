import 'package:flutter/material.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/features/address/domain/entities/address_entity.dart';

class AddressDetails extends StatelessWidget {
  final AddressEntity address;

  const AddressDetails({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(address.fullName, style: context.textTheme.bodyMedium),
        AppSpacing.h_4.hSpace,
        Text(address.phone),
        AppSpacing.h_4.hSpace,
        Text(
          '${address.fullAddress}'
          '${address.building == null ? '' : ', ${address.building}'}',
        ),
        if (address.notes != null && address.notes!.isNotEmpty) ...[
          AppSpacing.h_4.hSpace,
          Text(address.notes!, style: context.textTheme.bodySmall),
        ],
      ],
    );
  }
}
