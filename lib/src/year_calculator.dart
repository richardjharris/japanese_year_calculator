import 'package:japanese_year_calculator/src/settings/settings_service.dart';
import 'package:japanese_year_calculator/src/era_data.dart' as era_data;

/// Defines an era (known as 元号 in Japan) with its initial Western year and
/// its title in various forms.
class JapaneseEra {
  /// The Western year corresponding to year 1 for this era.
  final int startYear;

  /// The Kanji form of the era, e.g. "令和".
  final String kanjiTitle;

  /// The kana form of the era, e.g. "れいわ". Multiple forms can be provided,
  /// separated by '/'.
  final String kanaTitles;

  /// The Romaji form of the era, e.g. "Reiwa". Multiple forms can be provided,
  /// separated by '/' (in the same order as [kanaTitle]).
  final String romajiTitles;

  String get kanaTitle => kanaTitles.split('/').first;
  String get romajiTitle => romajiTitles.split('/').first;
  bool get isUnnamed => kanjiTitle == '－';

  const JapaneseEra(
      this.startYear, this.kanjiTitle, this.kanaTitles, this.romajiTitles);

  /// Constructor for eras that have no official name.
  const JapaneseEra.unnamed(int startYear) : this(startYear, '－', '－', '－');
}

/// Holds a Japanese year [era] (Reiwa, Showa etc.) and year [index] (1 for the
/// first year).
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
  /// Returns a list of all known year ranges, earliest first.
  static List<JapaneseEra> get allEras => era_data.eras;

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
    final era = allEras.lastWhere((era) => westernYear >= era.startYear);

    return JapaneseYear(era: era, index: westernYear - era.startYear + 1);
  }

  /// Returns all relevant nengos for the given western year, ordered earliest
  /// first.
  ///
  /// For example, `getAllJapaneseYears(2019)` will return both Reiwa 1 and
  /// Heisei 31.
  ///
  /// For the year 686, returns three eras, as the year contained an era that
  /// lasted only two months, in addition to two at either end.
  ///
  /// Throws a [StateError] if the year is not covered by this calculator.
  static List<JapaneseYear> getAllJapaneseYears(int westernYear) {
    List matches = <JapaneseYear>[];

    for (int i = allEras.length - 1; i >= 0; i--) {
      final era = allEras[i];
      int index = westernYear - era.startYear + 1;
      if (index < 1) {
        continue;
      }

      matches.add(JapaneseYear(era: era, index: index));

      /// Look further back for other era matches.
      while (index == 1 && i > 0) {
        i -= 1;

        /// Corresponds to the final year of the previous era.
        final previousEra = allEras[i];
        final previousIndex = westernYear - previousEra.startYear + 1;
        matches.add(JapaneseYear(era: previousEra, index: previousIndex));

        /// For some years like 686, the previousEra is only one year
        /// long, so we need to look further back.
        index = previousIndex;
      }
      break;
    }

    return (matches as List<JapaneseYear>);
  }
}
