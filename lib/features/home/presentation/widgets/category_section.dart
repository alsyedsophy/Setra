import 'package:flutter/widgets.dart';
import 'package:setra/features/home/presentation/widgets/category_banner.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CategoryBanner(padding: 0, height: 250),
        // Row(
        //   children: [
        //     CategoryBanner(
        //       padding: 0,
        //       height: 300,
        //       paddingRL: 10,
        //       paddingBottom: 40,
        //     ).expanded,
        //     CategoryBanner(
        //       padding: 0,
        //       height: 300,
        //       paddingRL: 10,
        //       paddingBottom: 40,
        //     ).expanded,
        //   ],
        // ),
      ],
    );
  }
}
