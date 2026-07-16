import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../storage/storage_service.dart';
import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(this._storageService) : super(const LocaleState());

  final StorageService _storageService;

  static const List<Locale> supported = [Locale('en'), Locale('ar')];

  /// Restores the saved locale, if any. Called once on startup.
  Future<void> loadLocale() async {
    final String? saved = await _storageService.getLocale();
    if (saved == null) {
      return;
    }
    final Locale? match = _resolve(saved);
    if (match != null) {
      emit(state.copyWith(locale: match));
    }
  }

  Future<void> setLocale(Locale locale) async {
    final Locale? match = _resolve(locale.languageCode);
    if (match == null || match.languageCode == state.locale.languageCode) {
      return;
    }
    emit(state.copyWith(locale: match));
    await _storageService.setLocale(match.languageCode);
  }

  Locale? _resolve(String languageCode) {
    for (final Locale locale in supported) {
      if (locale.languageCode == languageCode) {
        return locale;
      }
    }
    return null;
  }
}
