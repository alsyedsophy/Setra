import 'package:flutter/widgets.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/extensions/extensions.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.title, required this.onTap});
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(title, style: context.textTheme.headlineLarge),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            "VIEW ALL",
            style: context.textTheme.titleSmall,
          ).onTap(onTap),
        ),
      ],
    ).paddingHorizontal(AppSpacing.w_10);
  }
}
