import 'package:flutter/material.dart';

import 'package:japanese_year_calculator/src/localization/app_localizations_context.dart';
import 'package:japanese_year_calculator/src/settings/settings_service.dart';
import 'settings_controller.dart';

class SettingLeft extends StatelessWidget {
  final String title;

  const SettingLeft({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            )));
  }
}

class SettingRight extends StatelessWidget {
  final Widget child;

  const SettingRight({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Padding(padding: const EdgeInsets.all(8.0), child: child));
  }
}

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({Key? key, required this.controller}) : super(key: key);

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.loc.settings),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            children: [
              Row(
                children: [
                  SettingLeft(title: context.loc.theme),
                  SettingRight(child: ThemeSelector(controller)),
                ],
              ),
              Row(
                children: [
                  SettingLeft(title: context.loc.appLanguage),
                  SettingRight(child: AppLanguageSelector(controller)),
                ],
              ),
              Row(
                children: [
                  SettingLeft(title: context.loc.dateLanguage),
                  SettingRight(child: DateLanguageSelector(controller)),
                ],
              ),
            ],
          ),
        ));
  }
}

class ThemeSelector extends StatelessWidget {
  final SettingsController controller;

  // ignore: use_key_in_widget_constructors
  const ThemeSelector(this.controller);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ThemeMode>(
      // Read the selected themeMode from the controller
      value: controller.themeMode,
      // Call the updateThemeMode method any time the user selects a theme.
      onChanged: controller.updateThemeMode,
      items: [
        DropdownMenuItem(
          value: ThemeMode.system,
          child: Text(context.loc.systemTheme),
        ),
        DropdownMenuItem(
          value: ThemeMode.light,
          child: Text(context.loc.lightTheme),
        ),
        DropdownMenuItem(
          value: ThemeMode.dark,
          child: Text(context.loc.darkTheme),
        )
      ],
    );
  }
}

class DateLanguageSelector extends StatelessWidget {
  final SettingsController controller;

  // ignore: use_key_in_widget_constructors
  const DateLanguageSelector(this.controller);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<DateLanguagePreference>(
      value: controller.dateLanguage,
      onChanged: controller.updateDateLanguage,
      items: [
        DropdownMenuItem(
          value: DateLanguagePreference.en,
          child: Text(context.loc.romajiDateSetting),
        ),
        DropdownMenuItem(
          value: DateLanguagePreference.ja,
          child: Text(context.loc.kanjiDateSetting),
        ),
      ],
    );
  }
}

class AppLanguageSelector extends StatelessWidget {
  final SettingsController controller;

  // ignore: use_key_in_widget_constructors
  const AppLanguageSelector(this.controller);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<AppLanguagePreference>(
      value: controller.appLanguage,
      onChanged: controller.updateAppLanguage,
      items: [
        DropdownMenuItem(
          value: AppLanguagePreference.system,
          child: Text(context.loc.systemLanguage),
        ),
        DropdownMenuItem(
          value: AppLanguagePreference.en,
          child: Text(context.loc.englishLanguage),
        ),
        DropdownMenuItem(
          value: AppLanguagePreference.ja,
          child: Text(context.loc.japaneseLanguage),
        ),
      ],
    );
  }
}
