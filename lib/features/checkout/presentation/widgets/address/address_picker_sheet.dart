import 'package:flutter/material.dart';
import 'package:setra/features/address/domain/entities/address_entity.dart';

class AddressPickerSheet extends StatelessWidget {
  final List<AddressEntity> addresses;
  final AddressEntity? selectedAddress;
  final ValueChanged<AddressEntity> onAddressSelected;
  final VoidCallback onAddNewAddress;

  const AddressPickerSheet({
    super.key,
    required this.addresses,
    required this.selectedAddress,
    required this.onAddressSelected,
    required this.onAddNewAddress,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select shipping address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            if (addresses.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'You have no saved addresses. Add an address first.',
                ),
              )
            else
              ...addresses.map((address) {
                final isSelected = selectedAddress?.id == address.id;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: Colors.black,
                  ),
                  title: Text(address.fullName),
                  subtitle: Text(
                    '${address.city}, ${address.area}, ${address.street}',
                  ),
                  onTap: () {
                    onAddressSelected(address);
                    Navigator.of(context).pop();
                  },
                );
              }),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onAddNewAddress();
                },
                child: const Text('Add New Address'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
