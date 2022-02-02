import 'package:flutter/material.dart';

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
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              const SettingLeft(title: 'Theme'),
              SettingRight(child: ThemeSelector(controller)),
            ],
          ),
          Row(
            children: [
              const SettingLeft(title: 'Language'),
              SettingRight(child: LanguageSelector(controller)),
            ],
          ),
        ],
      ),
    );
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
      items: const [
        DropdownMenuItem(
          value: ThemeMode.system,
          child: Text('System Theme'),
        ),
        DropdownMenuItem(
          value: ThemeMode.light,
          child: Text('Light Theme'),
        ),
        DropdownMenuItem(
          value: ThemeMode.dark,
          child: Text('Dark Theme'),
        )
      ],
    );
  }
}

class LanguageSelector extends StatelessWidget {
  final SettingsController controller;

  // ignore: use_key_in_widget_constructors
  const LanguageSelector(this.controller);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: controller.language,
      onChanged: controller.updateLanguage,
      items: const [
        DropdownMenuItem(
          value: 'en',
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: 'ja',
          child: Text('Japanese'),
        ),
      ],
    );
  }
}
