import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:japanese_year_calculator/src/settings/settings_controller.dart';
import 'package:japanese_year_calculator/src/settings/settings_service.dart';
import 'package:japanese_year_calculator/src/year_calculator.dart';
import 'package:japanese_year_calculator/src/settings/settings_view.dart';
import 'package:japanese_year_calculator/src/localization/app_localizations_context.dart';

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

/// Widget to jump directly to a specific year.
class YearSelector extends StatefulWidget {
  final ValueSetter<int> onSelected;
  final VoidCallback onInvalid;

  const YearSelector(
      {Key? key, required this.onSelected, required this.onInvalid})
      : super(key: key);

  @override
  _YearSelectorState createState() => _YearSelectorState();
}

class _YearSelectorState extends State<YearSelector> {
  final TextEditingController _yearInputController = TextEditingController();
  final FocusNode _yearInputFocusNode = FocusNode();

  @override
  void dispose() {
    _yearInputController.dispose();
    _yearInputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextField(
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: context.loc.enterWesternYearHint,
            filled: true,
            fillColor: Theme.of(context).primaryColorLight,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _yearInputController.clear();
              },
            ),
            // Hide the '0/4' helper text that would show because we have [maxLength] set.
            counterText: '',
          ),
          maxLength: 4,
          controller: _yearInputController,
          focusNode: _yearInputFocusNode,
          onEditingComplete: _onSubmit,
        )),
        Container(
            margin: const EdgeInsets.only(left: 10),
            child: ElevatedButton(
              child: Text(context.loc.convertYearButton),
              onPressed: _onSubmit,
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(100, 48),
              ),
            )),
      ],
    );
  }

  void _onSubmit() async {
    final year = int.tryParse(_yearInputController.text);
    if (year != null) {
      widget.onSelected(year);
      _yearInputController.clear();
    } else {
      //_yearInputFocusNode.requestFocus();
      widget.onInvalid();
    }
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
              final year = DialWheelSettings.firstYear + index;
              final japaneseYear = YearCalculator.getJapaneseYear(year);
              final japaneseYearLabel =
                  japaneseYear.toLocalizedString(language: dialLanguage);
              return Row(children: [
                Expanded(
                    flex: 5,
                    child: Text(
                      '$year',
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.right,
                    )),
                const SizedBox(width: 30),
                Expanded(
                    flex: 5,
                    child: Text(
                      japaneseYearLabel,
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                    )),
              ]);
            },
            childCount: DialWheelSettings.numYears,
          ),
        ));
  }
}
