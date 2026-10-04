import 'package:flutter/material.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/core/extensions/num_extensions.dart';

class ProductReview extends StatelessWidget {
  const ProductReview({super.key, required this.rating, this.reviewCount});

  final double rating;
  final int? reviewCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("REVIEWS", style: context.textTheme.bodySmall),
        AppSpacing.h_6.hSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Review Count: $reviewCount",
              style: context.textTheme.bodySmall,
            ),
            Row(
              children: [
                Text("Rating: ", style: context.textTheme.bodySmall),
                ...List.generate(5, (index) {
                  return Icon(
                    _getStarIcon(index, rating),
                    size: AppSpacing.s_20,
                    color: index < rating ? Colors.amber : Colors.grey.shade300,
                  );
                }),
              ],
            ),
          ],
        ),
      ],
    ).paddingHorizontal(AppSpacing.w_16);
  }

  IconData _getStarIcon(int index, double currentRating) {
    if (index < currentRating.floor()) {
      return Icons.star; // نجمة ممتلئة
    } else if (index < currentRating) {
      return Icons.star_half; // نجمة نصف ممتلئة للقيم العشرية (مثل 4.5)
    } else {
      return Icons.star_border; // نجمة فارغة
    }
  }
}
