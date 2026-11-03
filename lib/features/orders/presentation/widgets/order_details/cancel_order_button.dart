import 'package:flutter/material.dart';

import '../cancel_order_dialog.dart';

class CancelOrderButton extends StatelessWidget {
  final VoidCallback onCancel;

  const CancelOrderButton({super.key, required this.onCancel});

  Future<void> _handlePressed(BuildContext context) async {
    final confirmed = await showCancelOrderDialog(context);
    if (confirmed && context.mounted) onCancel();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: () => _handlePressed(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Cancel Order',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
