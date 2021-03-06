/// Unit tests for the YearCalculator.
import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_year_calculator/src/core/year_calculator.dart';

void main() {
  group('getJapaneseYear', () {
    test('should calculate newest era correctly', () {
      expect(YearCalculator.getJapaneseYear(2019).toRomaji(), 'Reiwa 1');
      expect(YearCalculator.getJapaneseYear(2020).toRomaji(), 'Reiwa 2');
      expect(YearCalculator.getJapaneseYear(2021).toRomaji(), 'Reiwa 3');
      expect(YearCalculator.getJapaneseYear(2030).toRomaji(), 'Reiwa 12');
    });

    test('should calculate other eras correctly', () {
      expect(YearCalculator.getJapaneseYear(2018).toRomaji(), 'Heisei 30');
      expect(YearCalculator.getJapaneseYear(2017).toRomaji(), 'Heisei 29');
      expect(YearCalculator.getJapaneseYear(2016).toRomaji(), 'Heisei 28');
      expect(YearCalculator.getJapaneseYear(1989).toRomaji(), 'Heisei 1');
      expect(YearCalculator.getJapaneseYear(1988).toRomaji(), 'Shōwa 63');
      expect(YearCalculator.getJapaneseYear(1985).toRomaji(), 'Shōwa 60');
      expect(YearCalculator.getJapaneseYear(1868).toRomaji(), 'Meiji 1');
      expect(YearCalculator.getJapaneseYear(1869).toRomaji(), 'Meiji 2');
      expect(YearCalculator.getJapaneseYear(1911).toRomaji(), 'Meiji 44');
      expect(YearCalculator.getJapaneseYear(1912).toRomaji(), 'Taishō 1');
    });

    test('should handle invalid years', () {
      expect(
          () => YearCalculator.getJapaneseYear(0), throwsA(isA<StateError>()));
      expect(
          () => YearCalculator.getJapaneseYear(-1), throwsA(isA<StateError>()));
      // We have no data prior to 645.
      expect(() => YearCalculator.getJapaneseYear(300),
          throwsA(isA<StateError>()));
    });
  });

  group('getAllJapaneseYears', () {
    test('should return one year if applicable', () {
      expect(YearCalculator.getAllJapaneseYears(2022).map((y) => y.toRomaji()),
          ['Reiwa 4']);
    });

    test('should return two years if applicable', () {
      expect(YearCalculator.getAllJapaneseYears(1912).map((y) => y.toRomaji()),
          ['Taishō 1', 'Meiji 45']);
      expect(YearCalculator.getAllJapaneseYears(2019).map((y) => y.toRomaji()),
          ['Reiwa 1', 'Heisei 31']);
    });

    test('should return three years if applicable', () {
      expect(YearCalculator.getAllJapaneseYears(686).map((y) => y.toRomaji()),
          ['－ 1', 'Shuchō 1', '－ 33']);
    });
  });

  test('should return earliestWesternYear', () {
    expect(YearCalculator.earliestWesternYear, 645);
  });

  test('should expose list of all year ranges', () {
    expect(YearCalculator.allEras, isNotEmpty);
  });
}
