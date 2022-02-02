import 'package:japanese_year_calculator/src/settings/settings_service.dart';

/// Defines a range of years (known as 元号 in Japan) with its Romaji and
/// Kanji titles.
///
/// The current era will have an [endYear] of null.
class JapaneseEra {
  final String romajiTitle;
  final String kanjiTitle;
  final int startYear;
  final int? endYear;

  const JapaneseEra(
      this.romajiTitle, this.kanjiTitle, this.startYear, this.endYear);

  /// Returns true if this era contains the given year.
  bool contains(int westernYear) =>
      westernYear >= startYear && (endYear == null || westernYear <= endYear!);
}

/// Holds a Japanese year [era] (Reiwa, Showa etc.) and [index] (1 for the first year).
class JapaneseYear {
  final JapaneseEra era;
  final int index;

  const JapaneseYear({required this.era, required this.index})
      : assert(index > 0);

  /// Returns true if this year is the founding year for its era.
  bool get isFoundingYear => index == 1;

  String toRomaji() => '${era.romajiTitle} $index';
  String toKanji() => '${era.kanjiTitle} $index';

  String toLocalizedString({required DateLanguagePreference language}) {
    switch (language) {
      case DateLanguagePreference.en:
        return toRomaji();
      case DateLanguagePreference.ja:
        return toKanji();
    }
  }
}

class YearCalculator {
  static const _eras = [
    JapaneseEra("Meiji", "明治", 1868, 1912),
    JapaneseEra("Taishō", "大正", 1912, 1926),
    JapaneseEra("Shōwa", "昭和", 1926, 1989),
    JapaneseEra("Heisei", "平成", 1989, 2019),
    JapaneseEra("Reiwa", "令和", 2019, null),
  ];

  /// Returns a list of all known year ranges.
  static List<JapaneseEra> get allEras => _eras;

  /// Returns the earliest Western year that we can calculate a Japanese year for.
  static int get earliestWesternYear => allEras.first.startYear;

  /// Returns the year under the most recent possible era for the given Western
  /// year.
  ///
  /// For example, `getJapaneseYear(2019)` will return a result of 'Reiwa 1',
  /// even though 2019 is also 'Heisei 31' for the first 5 months of the year.
  ///
  /// Throws a [StateError] if the year is not covered by this calculator.
  static JapaneseYear getJapaneseYear(int westernYear) {
    final era = allEras.lastWhere((era) => era.contains(westernYear));

    return JapaneseYear(era: era, index: westernYear - era.startYear + 1);
  }

  /// Returns all relevant nengos for the given western year, ordered earliest
  /// first.
  ///
  /// For example, `getAllJapaneseYears(2019)` will return both Reiwa 1 and
  /// Heisei 31.
  static List<JapaneseYear> getAllJapaneseYears(int westernYear) {
    var list = [getJapaneseYear(westernYear)];
    if (list.first.isFoundingYear) {
      var previousYear = getJapaneseYear(westernYear - 1);
      list.insert(0,
          JapaneseYear(era: previousYear.era, index: previousYear.index + 1));
    }
    return list;
  }
}
