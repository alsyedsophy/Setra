import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// Immutable state holding the application's active [Locale].
class LocaleState extends Equatable {
  const LocaleState({this.locale = const Locale('en')});

  final Locale locale;

  /// Convenience flag for right-to-left languages (Arabic).
  bool get isRtl => locale.languageCode == 'ar';

  LocaleState copyWith({Locale? locale}) {
    return LocaleState(locale: locale ?? this.locale);
  }

  @override
  List<Object?> get props => [locale.languageCode];
}
