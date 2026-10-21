import 'package:flutter/material.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/num_extensions.dart';
import 'package:setra/core/widgets/widgets.dart';

class ProductImagePage extends StatefulWidget {
  const ProductImagePage({
    super.key,
    required this.images,
    required this.targetIndex,
  });

  final List<String> images;
  final int targetIndex;

  @override
  State<ProductImagePage> createState() => _ProductImagePageState();
}

class _ProductImagePageState extends State<ProductImagePage> {
  late final PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.targetIndex;
    _pageController = PageController(initialPage: widget.targetIndex);
  }

  @override
  void didUpdateWidget(covariant ProductImagePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetIndex != widget.targetIndex) {
      _currentPage = widget.targetIndex;
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return SizedBox(
        height: AppSpacing.h_400,
        child: const Center(child: Icon(Icons.image_not_supported_outlined)),
      );
    }
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
