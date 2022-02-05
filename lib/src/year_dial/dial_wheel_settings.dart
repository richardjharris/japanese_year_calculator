import 'package:clock/clock.dart';
import 'package:japanese_year_calculator/src/core/year_calculator.dart';

class DialWheelSettings {
  static const futureYearsToShow = 10;
  static const itemHeight = 50.0;

  static final firstYear = YearCalculator.earliestWesternYear;
  static final lastYear = clock.now().year + futureYearsToShow;

  static final numYears = lastYear - firstYear + 1;
}
