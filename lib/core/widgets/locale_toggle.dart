import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../localization/localization.dart';

/// Reusable language switcher.
///
/// Applies the selection to easy_localization (so all `.tr()` calls and text
/// direction update immediately) and persists it through [LocaleCubit].
class LocaleToggle extends StatelessWidget {
  const LocaleToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return SegmentedButton<String>(
          segments: <ButtonSegment<String>>[
            ButtonSegment<String>(
              value: 'en',
              label: Text(context.l10n.tr('english')),
            ),
            ButtonSegment<String>(
              value: 'ar',
              label: Text(context.l10n.tr('arabic')),
            ),
          ],
          selected: <String>{state.locale.languageCode},
          onSelectionChanged: (Set<String> selection) =>
              _onChanged(context, selection.first),
        );
      },
    );
  }

  Future<void> _onChanged(BuildContext context, String languageCode) async {
    final Locale locale = Locale(languageCode);
    context.setLocale(locale);
    await context.read<LocaleCubit>().setLocale(locale);
  }
}
