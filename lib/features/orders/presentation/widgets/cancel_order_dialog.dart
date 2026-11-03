import 'package:flutter/material.dart';

/// يعرض Dialog لتأكيد إلغاء الطلب.
/// يُرجع `true` إذا وافق المستخدم على الإلغاء.
Future<bool> showCancelOrderDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Cancel Order?'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep Order'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Cancel Order',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
