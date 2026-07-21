import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/extensions/widget_extensions.dart';
import 'package:setra/core/localization/localization.dart';
import 'package:setra/core/routing/route_paths.dart';

class RegisterText extends StatelessWidget {
  const RegisterText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          RichText(
            text: TextSpan(
              text: context.l10n.tr(L10nKeys.dontHaveAccount),
              style: context.textTheme.bodySmall,
              children: [
                TextSpan(
                  text: context.l10n.tr(L10nKeys.createAccount),
                  style: context.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ).onTap(() {
            context.pushNamed(RoutePaths.registerName);
          }),
    );
  }
}
