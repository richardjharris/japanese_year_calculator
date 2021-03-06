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

  /// The current theme preference (light, dark or system)
  late ThemeMode _themeMode;

  /// The current app language preference ('en' or 'ja')
  late AppLanguagePreference _appLanguage;

  /// The language used for showing Japanese dates on the dial.
  late DateLanguagePreference _dateLanguage;

  /// Preference for era list display order.
  late EraListDisplayOrderPreference _eraListDisplayOrder;

  /// Returns the user's preferred [ThemeMode].
  ThemeMode get themeMode => _themeMode;

  /// Returns the user's preferred language for the application.
  AppLanguagePreference get appLanguage => _appLanguage;

  /// Returns the user's preferred language for Japanese dates.
  DateLanguagePreference get dateLanguage => _dateLanguage;

  /// Returns the user's preferred era list display order.
  EraListDisplayOrderPreference get eraListDisplayOrder => _eraListDisplayOrder;

  Locale? appLocale() {
    switch (appLanguage) {
      case AppLanguagePreference.en:
        return const Locale('en');
      case AppLanguagePreference.ja:
        return const Locale('ja');
      case AppLanguagePreference.system:
        return null;
    }
  }

  /// Load all settings from the backend. Can be used prior to building the root
  /// widget in order to prevent a 'flash' of changes after the first render.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _appLanguage = await _settingsService.appLanguage();
    _dateLanguage = await _settingsService.dateLanguage();
    _eraListDisplayOrder = await _settingsService.eraListDisplayOrder();

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

  Future<void> updateAppLanguage(AppLanguagePreference? language) async {
    if (language == null) return;
    if (language == _appLanguage) return;

    _appLanguage = language;
    notifyListeners();
    await _settingsService.updateAppLanguage(language);

    // When changing language, change the dial language to match. User can
    // override it afterwards.
    switch (_appLanguage) {
      case AppLanguagePreference.en:
        await updateDateLanguage(DateLanguagePreference.en);
        break;
      case AppLanguagePreference.ja:
        await updateDateLanguage(DateLanguagePreference.ja);
        break;
      case AppLanguagePreference.system:
        // do nothing
        break;
    }
  }

  Future<void> updateDateLanguage(DateLanguagePreference? language) async {
    if (language == null) return;
    if (language == _dateLanguage) return;

    _dateLanguage = language;
    notifyListeners();
    await _settingsService.updateDateLanguage(language);
  }

  Future<void> updateEraListDisplayOrder(
      EraListDisplayOrderPreference? order) async {
    if (order == null) return;
    if (order == _eraListDisplayOrder) return;

    _eraListDisplayOrder = order;
    notifyListeners();
    await _settingsService.updateEraListDisplayOrder(order);
  }

  Future<void> toggleEraListDisplayOrder() async {
    final newOrder =
        _eraListDisplayOrder == EraListDisplayOrderPreference.newestFirst
            ? EraListDisplayOrderPreference.oldestFirst
            : EraListDisplayOrderPreference.newestFirst;
    return updateEraListDisplayOrder(newOrder);
  }
}
