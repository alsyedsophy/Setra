import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

extension L10nExtension on BuildContext {
  L10nHelper get l10n => const L10nHelper();
}

class L10nHelper {
  const L10nHelper();

  String tr(
    String key, {
    List<String>? args,
    Map<String, String>? namedArgs,
    String? gender,
  }) => key.tr(args: args, namedArgs: namedArgs, gender: gender);
}
