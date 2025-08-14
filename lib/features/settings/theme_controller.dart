import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/secure_storage_provider.dart';

enum AppThemeMode { system, light, dark }

AppThemeMode _fromString(String? value) {
  switch (value) {
    case 'light':
      return AppThemeMode.light;
    case 'dark':
      return AppThemeMode.dark;
    case 'system':
    default:
      return AppThemeMode.system;
  }
}

String _toString(AppThemeMode mode) {
  switch (mode) {
    case AppThemeMode.light:
      return 'light';
    case AppThemeMode.dark:
      return 'dark';
    case AppThemeMode.system:
      return 'system';
  }
}

class ThemeController extends StateNotifier<AppThemeMode> {
  ThemeController(this._ref) : super(AppThemeMode.system) {
    _load();
  }

  final Ref _ref;

  Future<void> _load() async {
    final storage = _ref.read(secureStorageProvider);
    final stored = await storage.readThemeMode();
    state = _fromString(stored);
  }

  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;
    final storage = _ref.read(secureStorageProvider);
    await storage.saveThemeMode(_toString(mode));
  }

  ThemeMode get materialThemeMode {
    switch (state) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}

final themeControllerProvider =
    StateNotifierProvider<ThemeController, AppThemeMode>((ref) {
  return ThemeController(ref);
});


