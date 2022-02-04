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
    // Determine whether to use romaji or kana in era list.
    final useKana = settings.dateLanguage == DateLanguagePreference.ja;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.info),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        alignment: Alignment.center,
        child: ScrollableEraList(
          displayOrder: settings.eraListDisplayOrder,
          useKana: useKana,
        ),
      ),
      floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            child: const Icon(Icons.swap_vert),
            tooltip: context.loc.reverseEraListOrder,
            onPressed: () {
              settings.toggleEraListDisplayOrder();
            },
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// Scrollable list of eras that expands to fit available size.
class ScrollableEraList extends StatelessWidget {
  static final eraData = YearCalculator.allEras;
  static const style = TextStyle(fontSize: 20);

  // Display order of eras. If changed, will animate a slide transition to the
  // new order.
  final EraListDisplayOrderPreference displayOrder;

  // Whether to use kana (as opposed to romaji) for the second column.
  final bool useKana;

  const ScrollableEraList({
    Key? key,
    required this.displayOrder,
    required this.useKana,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TableRow header = _buildEraListHeader(context);
    List<TableRow> rows = _buildEraListRows(Theme.of(context).disabledColor);

    /// We build two versions of the same era list (one oldest first, one newest
    /// first) and animate between them.
    Table _makeTable(List<TableRow> rows, Key key) => Table(
          key: key,
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          //textBaseline: TextBaseline.ideographic,
          columnWidths: const {
            0: FixedColumnWidth(80),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(50),
            3: FixedColumnWidth(30),
            4: FixedColumnWidth(50),
          },
          children: [header, ...rows],
        );

    return SingleChildScrollView(
      restorationId: 'eraList',
      child: Center(
        child: Card(
          // Leave space for the floating action button
          margin: const EdgeInsets.only(bottom: 45.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600.0),
            padding: const EdgeInsets.all(20.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              //switchInCurve: Curves.easeOutExpo,
              //switchOutCurve: Curves.easeInExpo,
              child: displayOrder == EraListDisplayOrderPreference.newestFirst
                  ? _makeTable(
                      rows.reversed.toList(), const ValueKey('newestFirst'))
                  : _makeTable(rows.toList(), const ValueKey('oldestFirst')),
              transitionBuilder: (child, animation) {
                // Transition behaves as if the oldestFirst table is left of the
                // newestFirst table, and we slide horizontally between them.
                // Therefore the oldestFirst x transition is from -1.0 to 0.0,
                // and the newestFirst x transition is from 0.0 to 1.0.
                final offsetAnimation =
                    (child.key == const ValueKey('oldestFirst')
                            ? Tween(
                                begin: const Offset(-1.0, 0.0),
                                end: const Offset(0.0, 0.0),
                              )
                            : Tween(
                                begin: const Offset(1.0, 0.0),
                                end: const Offset(0.0, 0.0),
                              ))
                        .animate(animation);

                return ClipRect(
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> _buildEraListRows(Color endYearColor) {
    return List<TableRow>.generate(eraData.length, (i) {
      final era = eraData[i];
      final endYear = i < eraData.length - 1 ? eraData[i + 1].startYear : null;

      Widget kanjiText = Text(era.kanjiTitle, style: style);
      if (era.kanjiTitle.length == 4) {
        // Only a few eras are 4 chars long, compact them
        kanjiText = Transform.scale(
            scaleX: 0.5, child: kanjiText, alignment: Alignment.centerLeft);
      }

      return TableRow(
        children: [
          kanjiText,
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child:
                Text(useKana ? era.kanaTitle : era.romajiTitle, style: style),
          ),
          Text(era.startYear.toString(),
              textAlign: TextAlign.right, style: style),
          const Text('-', textAlign: TextAlign.center, style: style),
          Text(
            endYear?.toString() ?? '',
            textAlign: TextAlign.left,
            style: style.copyWith(
              color: endYearColor,
            ),
          ),
        ].map(_addTopPadding).toList(),
      );
    }).toList();
  }

  TableRow _buildEraListHeader(BuildContext context) {
    return TableRow(
      children: <Widget>[
        EraTableHeaderCell.left(context.loc.kanjiHeading),
        FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: EraTableHeaderCell.left(
                useKana ? context.loc.kanaHeading : context.loc.romajiHeading)),
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
