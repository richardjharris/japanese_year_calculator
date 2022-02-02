import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:japanese_year_calculator/src/settings/settings_controller.dart';
import 'package:japanese_year_calculator/src/settings/settings_service.dart';
import 'package:japanese_year_calculator/src/year_calculator.dart';
import 'package:japanese_year_calculator/src/settings/settings_view.dart';
import 'package:japanese_year_calculator/src/localization/app_localizations_context.dart';
import 'package:japanese_year_calculator/src/year_dial/year_selector.dart';

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
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Restorable push means the state will persist across app restarts.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
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

/// Custom scroll behaviour to support mouse drag as well as mouse wheel.
class DesktopScreenBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class DialWheelSettings {
  static const futureYearsToShow = 9;
  static const itemHeight = 50.0;

  static final firstYear = YearCalculator.earliestWesternYear;
  static final lastYear = DateTime.now().year + futureYearsToShow;

  static final numYears = lastYear - firstYear + 1;
}

class DialWheelScrollController extends FixedExtentScrollController {
  final jumpDuration = const Duration(milliseconds: 500);
  final jumpCurve = Curves.easeInOutExpo;

  static final currentYearItemIndex =
      (DialWheelSettings.numYears - DialWheelSettings.futureYearsToShow - 1);

  DialWheelScrollController() : super(initialItem: currentYearItemIndex);

  void jumpToYear(int year) {
    final int itemIndex = year - DialWheelSettings.firstYear;
    super.animateToItem(itemIndex, duration: jumpDuration, curve: jumpCurve);
  }
}

class YearDialWheel extends StatelessWidget {
  final ScrollController scrollController;
  final DateLanguagePreference dialLanguage;

  const YearDialWheel(
      {Key? key,
      required this.scrollController,
      this.dialLanguage = DateLanguagePreference.en})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
        behavior: DesktopScreenBehavior(),
        child: ListWheelScrollView.useDelegate(
          // Helps remember the last scroll position when the user leaves the app (desired?)
          restorationId: 'yearDialWheel',
          itemExtent: DialWheelSettings.itemHeight,
          diameterRatio: 4.0,
          perspective: 0.003,
          magnification: 1.5,
          useMagnifier: true,
          controller: scrollController,
          physics: const FixedExtentScrollPhysics(),
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              final westernYear = DialWheelSettings.firstYear + index;
              print(
                  "builder: $westernYear  first ${DialWheelSettings.firstYear} last ${DialWheelSettings.lastYear}");

              if (westernYear < DialWheelSettings.firstYear ||
                  westernYear > DialWheelSettings.lastYear) {
                return null;
              }

              return Row(children: [
                Expanded(
                  flex: 5,
                  child: _westernYearLabel(westernYear),
                ),
                const SizedBox(width: 20),
                Expanded(flex: 5, child: _japaneseYearLabel(westernYear)),
              ]);
            },
            childCount: DialWheelSettings.numYears,
          ),
        ));
  }

  Widget _westernYearLabel(int westernYear) {
    return Text(
      '$westernYear',
      style: const TextStyle(fontSize: 20),
      textAlign: TextAlign.right,
    );
  }

  Widget _japaneseYearLabel(int westernYear) {
    print("_japaneseYearLabel: $westernYear");
    final japaneseYears = YearCalculator.getAllJapaneseYears(westernYear);

    List<Widget> items = [
      Text(
        japaneseYears.last.toLocalizedString(language: dialLanguage),
        style: const TextStyle(fontSize: 20),
        textAlign: TextAlign.left,
      )
    ];

    if (japaneseYears.length > 1) {
      assert(japaneseYears.length == 2);

      String altLabel =
          japaneseYears.first.toLocalizedString(language: dialLanguage);
      items.add(Text(
        ' ・ $altLabel',
        style: const TextStyle(fontSize: 10),
        textAlign: TextAlign.left,
      ));
    }

    return Row(children: items);
  }
}
