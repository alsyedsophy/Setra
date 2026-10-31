import 'package:flutter/material.dart';
import 'package:setra/features/address/domain/entities/address_entity.dart';

import 'address_details.dart';
import 'empty_address.dart';
import '../section_card.dart';

class ShippingAddressSection extends StatelessWidget {
  final List<AddressEntity> addresses;
  final AddressEntity? selectedAddress;
  final VoidCallback onChange;
  final VoidCallback onSelect;

  const ShippingAddressSection({
    super.key,
    required this.addresses,
    required this.selectedAddress,
    required this.onChange,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Shipping Address',
      trailing: TextButton(
        onPressed: onChange,
        child: Text(addresses.isEmpty ? 'Add address' : 'Change'),
      ),
      child: selectedAddress == null
          ? EmptyAddress(onSelect: onSelect)
          : AddressDetails(address: selectedAddress!),
    );
  }
}
