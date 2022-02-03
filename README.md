# japanese_year_calculator

A simple Flutter app that converts between Japanese and Western years.

## TODO

- Move app credits to Setting page
- Credit wikipedia
- Era list: make header sticky, stop using Table layout
- Era list: reverse option
- Era list: maybe show other kana/romaji forms
- Settings: add reverse option (?)
- Settings: allow kana option for era names

- Fix: The offending Expanded is currently placed inside a Padding widget.
  ( SizedBox.shrink ← Expanded ← Spacer ← Padding ← Table ← \_SingleChildViewport ← IgnorePointer-[GlobalKey#4fe99] ← Semantics ← Listener ← \_GestureSemantics ← ⋯)

## Development

### State management

This app follows the Flutter Skeleton 2.0 which uses traditional
stage management (i.e. passing controllers down the Widget tree).
The [SettingsController] manages settings changes, persisting them
to SharedPreferences, and rebuilding the app upon change.

### Directory layout

```
lib/src/(feature)            - Feature code (controller, service, view, widget)
lib/src/localization         - Localized messages
lib/src/year_calculator.dart - Calculator logic (non-Flutter)
lib/src/era_data.dart        - Era names and start years
lib/src/themes.dart          - Theming
lib/src/app.dart             - App routing
lib/main.dart                - App entry point
test/                        - Unit and widget tests
```

## Localization

This project generates localized messages based on arb files found in
the `lib/src/localization` directory. Currently, English and Japanese
are supported, and the locale can be overriden via the settings page.

Localization files are regenerated as part of the hot reload process,
and can be manually run via `flutter pub get`.
