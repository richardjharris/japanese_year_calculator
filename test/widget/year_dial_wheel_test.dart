import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:japanese_year_calculator/src/settings/settings_service.dart';
import 'package:japanese_year_calculator/src/year_dial/year_dial_wheel.dart';

Widget _makeTestScaffold(Widget body, {Locale? locale}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: locale,
    home: Scaffold(
      body: body,
    ),
  );
}

void main() {
  group('YearDialWheel', () {
    testWidgets('English wheel should show the correct years',
        (WidgetTester tester) async {
      withClock(Clock(() => DateTime(2022)), () async {
        final controller = DialWheelScrollController();
        final dialWheel = YearDialWheel(
          scrollController: controller,
          dialLanguage: DateLanguagePreference.en,
        );
        final scaffold = _makeTestScaffold(dialWheel);

        await tester.pumpWidget(scaffold);
        await tester.pumpAndSettle();
        expect(find.text('Reiwa 5'), findsOneWidget, reason: '2022 is Reiwa 5');

        Rect widgetRect = tester.getRect(find.text('Reiwa 5')).inflate(100);
        Offset screenCenter = tester.getCenter(find.byType(YearDialWheel));
        expect(widgetRect.contains(screenCenter), isTrue,
            reason: 'should be the central widget');

        controller.jumpToYear(1868);
        await tester.pumpAndSettle();
        expect(find.text('Meiji 1'), findsOneWidget, reason: '1985 is Meiji 1');
      });
    });

    testWidgets('Wheel should default to the current year',
        (WidgetTester tester) async {
      withClock(Clock(() => DateTime(1985)), () async {
        final controller = DialWheelScrollController();
        final dialWheel = YearDialWheel(
          scrollController: controller,
          dialLanguage: DateLanguagePreference.en,
        );
        final scaffold = _makeTestScaffold(dialWheel);

        await tester.pumpWidget(scaffold);
        await tester.pumpAndSettle();
        expect(find.text('Shōwa 60'), findsOneWidget,
            reason: '1985 is Shōwa 60');
      });
    });

    testWidgets('Wheel should be on Japanese if preferred',
        (WidgetTester tester) async {
      withClock(Clock(() => DateTime(2022)), () async {
        final controller = DialWheelScrollController();
        final dialWheel = YearDialWheel(
          scrollController: controller,
          dialLanguage: DateLanguagePreference.ja,
        );
        final scaffold = _makeTestScaffold(dialWheel);
        await tester.pumpWidget(scaffold);
        await tester.pumpAndSettle();
        expect(find.text('令和 5'), findsWidgets);
      });
    });
  });
}
