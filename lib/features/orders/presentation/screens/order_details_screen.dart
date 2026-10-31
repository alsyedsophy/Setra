import 'package:flutter/material.dart';
import 'package:setra/core/widgets/custom_app_bar.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isAuth: true),
      body: Center(child: Text('Order Details')),
    );
  }
}
