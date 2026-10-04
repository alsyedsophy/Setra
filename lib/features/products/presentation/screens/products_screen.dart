import 'package:flutter/material.dart';
import 'package:setra/core/widgets/custom_app_bar.dart';
import 'package:setra/features/home/presentation/widgets/custom_home_drawer.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomHomeDrawer(),
      body: Center(child: Text("Products")),
    );
  }
}
