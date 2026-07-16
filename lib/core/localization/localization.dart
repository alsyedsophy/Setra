import 'package:flutter/widgets.dart';

export 'l10n_extension.dart';
export 'locale_cubit.dart';
export 'locale_state.dart';

/// Locales supported by the application (English and Arabic).
const List<Locale> supportedLocales = <Locale>[
  Locale('en'),
  Locale('ar'),
];

/// Default locale used when no saved preference exists.
const Locale fallbackLocale = Locale('en');

/// Path to the translation assets, relative to the application root.
const String translationsPath = 'assets/translations';
