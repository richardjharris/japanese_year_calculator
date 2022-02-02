// This is an example Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
//
// Visit https://flutter.dev/docs/cookbook/testing/widget/introduction for
// more information about Widget testing.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:japanese_year_calculator/src/year_dial/year_selector.dart';

void main() {
  group('YearSelector', () {
    testWidgets('onSelected and onInvalid callbacks',
        (WidgetTester tester) async {
      List<String> calls = [];

      final yearSelector = YearSelector(
        onSelected: (year) {
          calls.add("selected $year");
        },
        onInvalid: () {
          calls.add('invalid');
        },
      );

      final scaffold = MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: yearSelector,
        ),
      );

      await tester.pumpWidget(scaffold);
      expect(find.text('Lookup'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '1985');
      await tester.tap(find.text('Lookup'));
      expect(calls, ['selected 1985']);

      calls = [];
      await tester.enterText(find.byType(TextField), 'abc');
      await tester.tap(find.text('Lookup'));
      expect(calls, ['invalid']);
    });

    testWidgets('Japanese locale', (WidgetTester tester) async {
      final scaffold = MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ja', 'JP'),
        home: Scaffold(
          body: YearSelector(onInvalid: () {}, onSelected: (_) {}),
        ),
      );

      await tester.pumpWidget(scaffold);
      expect(find.text('変換'), findsOneWidget);
    });
  });
}
