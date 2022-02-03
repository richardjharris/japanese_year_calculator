import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguagePreference { en, ja, system }

enum DateLanguagePreference { en, ja }

enum EraListDisplayOrderPreference { oldestFirst, newestFirst }

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    final SharedPreferences prefs = await _prefs;
    final String mode = prefs.getString('themeMode') ?? 'system';
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('themeMode', theme.name);
  }

  Future<AppLanguagePreference> appLanguage() async {
    final SharedPreferences prefs = await _prefs;
    final String language = prefs.getString('appLanguage') ?? 'system';
    switch (language) {
      case 'en':
        return AppLanguagePreference.en;
      case 'ja':
        return AppLanguagePreference.ja;
      case 'system':
      default:
        return AppLanguagePreference.system;
    }
  }

  Future<void> updateAppLanguage(AppLanguagePreference language) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('appLanguage', language.name);
  }

  Future<DateLanguagePreference> dateLanguage() async {
    final SharedPreferences prefs = await _prefs;
    final String language = prefs.getString('dateLanguage') ?? 'from_locale';
    switch (language) {
      case 'en':
        return DateLanguagePreference.en;
      case 'ja':
        return DateLanguagePreference.ja;
      case 'from_locale':
      default:
        return _dateLanguageFromPlatformLocale();
    }
  }

  Future<void> updateDateLanguage(DateLanguagePreference language) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('dateLanguage', language.name);
  }

  DateLanguagePreference _dateLanguageFromPlatformLocale() {
    switch (PlatformDispatcher.instance.locale.languageCode) {
      case 'ja':
        return DateLanguagePreference.ja;
      default:
        return DateLanguagePreference.en;
    }
  }

  Future<EraListDisplayOrderPreference> eraListDisplayOrder() async {
    final SharedPreferences prefs = await _prefs;
    final String order =
        prefs.getString('eraListDisplayOrder') ?? 'newestFirst';
    switch (order) {
      case 'oldestFirst':
        return EraListDisplayOrderPreference.oldestFirst;
      case 'newestFirst':
      default:
        return EraListDisplayOrderPreference.newestFirst;
    }
  }

  Future<void> updateEraListDisplayOrder(
      EraListDisplayOrderPreference order) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('eraListDisplayOrder', order.name);
  }
}
