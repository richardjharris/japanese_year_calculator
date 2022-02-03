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
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Expanded(
              child: ScrollableEraList(),
            ),
            AppCredits(),
          ],
        ),
      ),
    );
  }
}

class EraTableHeaderCell extends StatelessWidget {
  final String headerText;
  final TextAlign textAlign;

  const EraTableHeaderCell(this.headerText,
      {Key? key, this.textAlign = TextAlign.center})
      : super(key: key);

  const EraTableHeaderCell.left(this.headerText, {Key? key})
      : textAlign = TextAlign.left,
        super(key: key);

  static const headerStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Text(
      headerText,
      style: headerStyle,
      textAlign: textAlign,
    );
  }
}

Widget _addTopPadding(Widget widget) {
  return Padding(
    padding: const EdgeInsets.only(top: 12.0),
    child: widget,
  );
}

Widget _addTopAndBottomPadding(Widget widget) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: widget,
  );
}

TableRow _eraTableHeader(BuildContext context) {
  return TableRow(
    children: <Widget>[
      EraTableHeaderCell.left(context.loc.kanjiHeading),
      FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: EraTableHeaderCell.left(context.loc.romajiHeading)),
      EraTableHeaderCell(context.loc.fromYear),
      const Spacer(),
      EraTableHeaderCell(context.loc.untilYear),
    ].map(_addTopAndBottomPadding).toList(),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1.0,
        ),
      ),
    ),
  );
}

/// Scrollable list of eras that expands to fit available size.
class ScrollableEraList extends StatelessWidget {
  static final eraData = YearCalculator.allEras;

  const ScrollableEraList({Key? key}) : super(key: key);

  static const style = TextStyle(fontSize: 20);
  static final headerStyle = style.copyWith(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400.0),
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            textBaseline: TextBaseline.ideographic,
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: FixedColumnWidth(50),
              3: FixedColumnWidth(30),
              4: FixedColumnWidth(50),
            },
            children: [
              _eraTableHeader(context),
              ...List<TableRow>.generate(eraData.length, (i) {
                final era = eraData[i];
                final endYear =
                    i + 1 < eraData.length ? eraData[i + 1].startYear : null;
                return TableRow(
                  children: [
                    Text(era.kanjiTitle, style: style),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(era.romajiTitle, style: style),
                    ),
                    Text(era.startYear.toString(),
                        textAlign: TextAlign.right, style: style),
                    const Text('-', textAlign: TextAlign.center, style: style),
                    Text(
                      endYear?.toString() ?? '',
                      textAlign: TextAlign.left,
                      style: style.copyWith(
                          color: Theme.of(context).disabledColor),
                    ),
                  ].map(_addTopPadding).toList(),
                );
              }).reversed.toList(),
            ],
          ),
        ),
      ),
    );
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
