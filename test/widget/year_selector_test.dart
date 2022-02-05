import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:japanese_year_calculator/src/year_dial/year_selector.dart';

void main() {
  group('YearSelector', () {
    testWidgets('onSelected callback', (WidgetTester tester) async {
      List<String> calls = [];

      final yearSelector = YearSelector(
        onSelected: (year) {
          calls.add("selected $year");
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
      // Wait for button to enable itself
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lookup'));
      expect(calls, ['selected 1985']);

      calls = [];
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lookup'));
      expect(calls, []);
    });

    testWidgets('Japanese locale', (WidgetTester tester) async {
      final scaffold = MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ja', 'JP'),
        home: Scaffold(
          body: YearSelector(onSelected: (_) {}),
        ),
      );

      await tester.pumpWidget(scaffold);
      expect(find.text('変換'), findsOneWidget);
    });
  });
}
