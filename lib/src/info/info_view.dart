import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:japanese_year_calculator/src/localization/app_localizations_context.dart';
import 'package:japanese_year_calculator/src/year_calculator.dart';

/// Displays a list of eras, and app credits.
class InfoView extends StatelessWidget {
  const InfoView({Key? key}) : super(key: key);

  static const routeName = '/info';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.info),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Expanded(child: ScrollableEraList()),
            AppCredits(),
          ],
        ),
      ),
    );
  }
}

/// Scrollable list of eras that expands to fit available size.
class ScrollableEraList extends StatelessWidget {
  static final eraData = YearCalculator.allEras;

  const ScrollableEraList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
        children: eraData
            .map((era) => TableRow(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(era.kanjiTitle)),
                    Text(era.romajiTitle),
                    Text(era.startYear.toString()),
                    const Text('-'),
                    Text(era.endYear?.toString() ?? ''),
                  ],
                ))
            .toList());
  }
}

class AppCredits extends StatelessWidget {
  const AppCredits({Key? key}) : super(key: key);

  static final String email = String.fromCharCodes(
      base64.decode('cmljaGFyZGpoYXJyaXMranljQGdtYWlsLmNvbQ=='));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.loc.appCredits,
                style: Theme.of(context).textTheme.headline4),
            const SizedBox(height: 8.0),
            _creditsText(context),
          ],
        ),
      ),
    );
  }

  Widget _creditsText(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headline6!;
    final linkStyle = textStyle.copyWith(
      color: Theme.of(context).buttonTheme.colorScheme!.primary,
      decoration: TextDecoration.underline,
    );

    return RichText(
      text: TextSpan(
        text: context.loc.appCreditsBeforeEmail,
        style: textStyle,
        children: [
          TextSpan(
            text: email,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () => launch('mailto:$email'),
          ),
          TextSpan(text: context.loc.appCreditsAfterEmail, style: textStyle),
        ],
      ),
    );
  }
}
