import 'package:flutter/material.dart';

import 'package:japanese_year_calculator/src/localization/app_localizations_context.dart';
import 'package:japanese_year_calculator/src/core/year_calculator.dart';
import 'package:japanese_year_calculator/src/settings/settings_controller.dart';
import 'package:japanese_year_calculator/src/settings/settings_service.dart';

/// Displays a list of all eras.
class EraListView extends StatelessWidget {
  const EraListView({Key? key, required this.settings}) : super(key: key);

  static const routeName = '/eras';

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.info),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        alignment: Alignment.center,
        child: ScrollableEraList(
          displayOrder: settings.eraListDisplayOrder,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.swap_vert),
        tooltip: context.loc.reverseEraListOrder,
        onPressed: () {
          settings.toggleEraListDisplayOrder();
        },
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

  const ScrollableEraList({Key? key, required this.displayOrder})
      : super(key: key);

  final EraListDisplayOrderPreference displayOrder;

  static const style = TextStyle(fontSize: 20);
  static final headerStyle = style.copyWith(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      restorationId: 'eraList',
      child: Center(
        child: Card(
          // Leave space for the floating action button
          margin: const EdgeInsets.only(bottom: 75.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600.0),
            padding: const EdgeInsets.all(20.0),
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
                  final index =
                      displayOrder == EraListDisplayOrderPreference.newestFirst
                          ? eraData.length - i - 1
                          : i;
                  final era = eraData[index];
                  final endYear = index < eraData.length - 1
                      ? eraData[index + 1].startYear
                      : null;
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
                      const Text('-',
                          textAlign: TextAlign.center, style: style),
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
      ),
    );
  }
}
