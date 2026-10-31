import 'package:flutter/material.dart';
import 'package:setra/core/extensions/extensions.dart';

class PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const PaymentOption({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<bool>(
      groupValue: selected,
      onChanged: (_) => onTap(),
      child: Material(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: context.colorScheme.primary),
          title: Text(title, style: context.textTheme.bodyMedium),
          subtitle: Text(subtitle),
          trailing: Radio<bool>(value: true, activeColor: Colors.black),
          onTap: onTap,
        ),
      ),
    );
  }
}
