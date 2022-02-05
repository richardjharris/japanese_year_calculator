import 'package:clock/clock.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:japanese_year_calculator/src/settings/settings_service.dart';
import 'package:japanese_year_calculator/src/core/year_calculator.dart';
import 'package:japanese_year_calculator/src/year_dial/dial_wheel_settings.dart';

/// Custom scroll behaviour to support mouse drag as well as mouse wheel.
class DesktopScreenBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

// Scroll controller that can jump to a specific year, and starts at the current
// year by default.
class DialWheelScrollController extends FixedExtentScrollController {
  final jumpDuration = const Duration(milliseconds: 500);
  final jumpCurve = Curves.easeInOutExpo;

  factory DialWheelScrollController() {
    final thisYear = clock.now().year;
    final currentYearItemIndex = (DialWheelSettings.numYears -
            (DialWheelSettings.lastYear - thisYear) -
            1)
        .clamp(0, DialWheelSettings.numYears - 1);
    return DialWheelScrollController._(currentYearItemIndex);
  }

  DialWheelScrollController._(initialItem) : super(initialItem: initialItem);

  void jumpToYear(int year) {
    final int itemIndex = year - DialWheelSettings.firstYear;
    super.animateToItem(itemIndex, duration: jumpDuration, curve: jumpCurve);
  }
}

/// Shows a scrollable list of years.
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
    final japaneseYears = YearCalculator.getAllJapaneseYears(westernYear);

    List<Widget> items = [
      Text(
        japaneseYears.first.toLocalizedString(language: dialLanguage),
        style: const TextStyle(fontSize: 20),
        textAlign: TextAlign.left,
      )
    ];

    for (int i = 1; i < japaneseYears.length; i++) {
      String altLabel =
          japaneseYears[i].toLocalizedString(language: dialLanguage);
      items.add(Text(
        ' ・ $altLabel',
        style: const TextStyle(fontSize: 10),
        textAlign: TextAlign.left,
      ));
    }

    return Row(
      children: items,
      mainAxisSize: MainAxisSize.min,
    );
  }
}
