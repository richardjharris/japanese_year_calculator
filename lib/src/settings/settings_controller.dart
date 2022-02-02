import 'package:flutter/material.dart';

import 'settings_service.dart';

/// Class that allows settings to be read, updated or listened to for changes.
///
/// Bridges widgets with the SettingService backend.
///
/// We use the same mechanism as the Flutter skeleton 2.0 app, which means the
/// entire app is rebuilt whenever a setting is changed. This is fine for our
/// purposes as all settings are global (theme / language).
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;
  late ThemeMode _themeMode;
  late String _language;

  /// Returns the user's preferred [ThemeMode].
  ThemeMode get themeMode => _themeMode;

  /// Returns the user's preferred language.
  String get language => _language;

  /// Load all settings from the backend. Can be used prior to building the root
  /// widget in order to prevent a 'flash' of changes after the first render.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _language = await _settingsService.language();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory and persist it.
    _themeMode = newThemeMode;
    notifyListeners();
    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> updateLanguage(String? language) async {
    if (language == null) return;
    if (language == _language) return;

    _language = language;
    notifyListeners();
    await _settingsService.updateLanguage(language);
  }
}
