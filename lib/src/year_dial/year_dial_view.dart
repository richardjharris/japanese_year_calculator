import 'package:flutter/material.dart';
import 'package:japanese_year_calculator/src/info/info_view.dart';
import 'package:japanese_year_calculator/src/settings/settings_controller.dart';
import 'package:japanese_year_calculator/src/settings/settings_view.dart';
import 'package:japanese_year_calculator/src/localization/app_localizations_context.dart';
import 'package:japanese_year_calculator/src/year_dial/year_dial_wheel.dart';
import 'package:japanese_year_calculator/src/year_dial/year_selector.dart';

/// The home view, showing a scrollable dial of Western <-> Japanese years.
class YearDialView extends StatefulWidget {
  final SettingsController settings;

  const YearDialView({Key? key, required this.settings}) : super(key: key);

  static const routeName = '/';

  @override
  _YearDialViewState createState() => _YearDialViewState();
}

class _YearDialViewState extends State<YearDialView> {
  final DialWheelScrollController _dialWheelScrollController =
      DialWheelScrollController();

  final double yearSelectorHeight = 48;

  @override
  void dispose() {
    _dialWheelScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            tooltip: context.loc.infoTooltip,
            onPressed: () {
              // Restorable push means the state will persist across app restarts.
              Navigator.restorablePushNamed(context, InfoView.routeName);
            },
          ),
          SizedBox(width: 10.0),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: context.loc.settingsTooltip,
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
          SizedBox(width: 20.0),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: YearDialWheel(
              scrollController: _dialWheelScrollController,
              dialLanguage: widget.settings.dateLanguage,
            ),
          ),
          Container(
            height: yearSelectorHeight,
            margin: const EdgeInsets.all(10),
            child: YearSelector(
              onSelected: (year) {
                _dialWheelScrollController.jumpToYear(year);
              },
              onInvalid: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.loc.invalidYearError),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.fromLTRB(
                        15.0, 5.0, 15.0, 20.0 + yearSelectorHeight),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
