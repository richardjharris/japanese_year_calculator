import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:japanese_year_calculator/src/year_calculator.dart';

import '../settings/settings_view.dart';
import 'package:japanese_year_calculator/src/localization/app_localizations_context.dart';

class YearDialView extends StatelessWidget {
  const YearDialView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: const YearDialWheel(),
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

class YearDialWheel extends HookWidget {
  const YearDialWheel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const futureYearsToShow = 9;
    const itemHeight = 50.0;

    final firstYear = YearCalculator.earliestWesternYear;
    final lastYear = DateTime.now().year + futureYearsToShow;
    final numYears = lastYear - firstYear + 1;

    final dialScrollController = useScrollController(
      // Start at current year
      initialScrollOffset: itemHeight * (numYears - futureYearsToShow - 1),
    );

    return ScrollConfiguration(
        behavior: DesktopScreenBehavior(),
        child: ListWheelScrollView.useDelegate(
          // Helps remember the last scroll position when the user leaves the app (desired?)
          restorationId: 'yearDialWheel',
          itemExtent: itemHeight,
          diameterRatio: 4.0,
          //perspective: 0.005,
          //magnification: 1.5,
          //useMagnifier: true,
          //squeeze: 1.0,
          controller: dialScrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              final year = firstYear + index;
              final japaneseYear = YearCalculator.getJapaneseYear(year);
              final japaneseYearLabel = japaneseYear.toKanji();
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
            childCount: lastYear - firstYear + 1,
          ),
        ));
  }
}
