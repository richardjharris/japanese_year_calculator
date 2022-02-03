import 'package:japanese_year_calculator/src/core/year_calculator.dart';

class DialWheelSettings {
  static const futureYearsToShow = 9;
  static const itemHeight = 50.0;

  static final firstYear = YearCalculator.earliestWesternYear;
  static final lastYear = DateTime.now().year + futureYearsToShow;

  static final numYears = lastYear - firstYear + 1;
}
