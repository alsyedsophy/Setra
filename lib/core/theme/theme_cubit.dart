import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../storage/storage_service.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._storageService) : super(const ThemeState());

  final StorageService _storageService;

  Future<void> loadTheme() async {
    final ThemeMode? saved = await _storageService.getThemeMode();
    if (saved != null) {
      emit(state.copyWith(themeMode: saved));
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == state.themeMode) {
      return;
    }
    emit(state.copyWith(themeMode: mode));
    await _storageService.setThemeMode(mode);
  }
}
