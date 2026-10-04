import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/widgets/widgets.dart';

class ProductImagePage extends StatefulWidget {
  const ProductImagePage({super.key, required this.images});

  final List<String> images;

  @override
  State<ProductImagePage> createState() => _ProductImagePageState();
}

class _ProductImagePageState extends State<ProductImagePage> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.h_400,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() {
              _currentPage = index;
            }),
            itemBuilder: (context, index) {
              final image = widget.images[index];
              return AppNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                width: double.infinity,
                borderRadius: 0,
              );
            },
          ),
          if (widget.images.length > 1)
            Positioned(
              bottom: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: AppSpacing.w_4.mH,
                    width: _currentPage == index
                        ? AppSpacing.w_24
                        : AppSpacing.w_8,
                    height: AppSpacing.h_8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.black
                          : Colors.black38,
                      borderRadius: AppSpacing.r_12.rAll,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
