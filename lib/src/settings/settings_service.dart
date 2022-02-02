import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<String> language() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('language') ?? _defaultLanguageFromPlatformLocale();
  }

  Future<void> updateLanguage(String language) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('language', language);
  }

  String _defaultLanguageFromPlatformLocale() {
    switch (PlatformDispatcher.instance.locale.languageCode) {
      case 'ja':
        return 'ja';
      default:
        return 'en';
    }
  }
}
