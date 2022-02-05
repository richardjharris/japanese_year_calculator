import 'package:flutter/material.dart';

import 'package:japanese_year_calculator/src/localization/app_localizations_context.dart';
import 'package:japanese_year_calculator/src/settings/app_credits.dart';
import 'package:japanese_year_calculator/src/settings/settings_service.dart';
import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
///
/// App credits are shown at the bottom.
class SettingsView extends StatelessWidget {
  const SettingsView({Key? key, required this.settings}) : super(key: key);

  static const routeName = '/settings';

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.loc.settings),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownSettingsTile<ThemeMode>(
                      title: context.loc.theme,
                      value: settings.themeMode,
                      onChanged: settings.updateThemeMode,
                      items: {
                        ThemeMode.system: context.loc.systemTheme,
                        ThemeMode.light: context.loc.lightTheme,
                        ThemeMode.dark: context.loc.darkTheme,
                      },
                    ),
                    DropdownSettingsTile<AppLanguagePreference>(
                      title: context.loc.appLanguage,
                      value: settings.appLanguage,
                      onChanged: settings.updateAppLanguage,
                      items: {
                        AppLanguagePreference.system:
                            context.loc.systemLanguage,
                        AppLanguagePreference.en: context.loc.englishLanguage,
                        AppLanguagePreference.ja: context.loc.japaneseLanguage,
                      },
                    ),
                    DropdownSettingsTile<DateLanguagePreference>(
                      title: context.loc.dateLanguage,
                      value: settings.dateLanguage,
                      onChanged: settings.updateDateLanguage,
                      items: {
                        DateLanguagePreference.en:
                            context.loc.romajiDateSetting,
                        DateLanguagePreference.ja: context.loc.kanjiDateSetting,
                      },
                    ),
                  ],
                ),
              ),
              const AppCredits(),
            ])));
  }
}

class DropdownSettingsTile<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Map<T, String> items;
  final T value;
  final ValueChanged<T?> onChanged;

  const DropdownSettingsTile({
    Key? key,
    required this.title,
    this.subtitle,
    required this.items,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelLarge),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: Theme.of(context).textTheme.labelMedium),
        ],
        DropdownButton<T>(
          value: value,
          onChanged: onChanged,
          isExpanded: true,
          items: items.entries
              .map((item) =>
                  DropdownMenuItem(value: item.key, child: Text(item.value)))
              .toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
