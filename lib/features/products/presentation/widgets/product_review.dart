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
    final double starSize = context.responsive(
      mobile: AppSpacing.s_20,
      desktop: AppSpacing.s_25,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("REVIEWS", style: context.textTheme.bodySmall),
        AppSpacing.h_6.hSpace,
        Wrap(
          alignment: WrapAlignment.spaceBetween,
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
                    size: starSize,
                    color: index < rating ? Colors.amber : Colors.grey.shade300,
                  );
                }),
              ],
            ),
          ],
        ),
      ],
    );
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
