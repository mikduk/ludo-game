import 'package:chinczyk/controllers/game_page_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Sprawdza czy getRandomValue losuje wartości zbliżone do równomiernego rozkładu',
        () {
      const int numberOfRolls = 10000000;
      const int possibilities = 6;
      final Map<int, int> frequencyMap = {};

      for (int i = 0; i < numberOfRolls; i++) {
        final result = GamePageController.getRandomValue(possibilities, null);
        frequencyMap[result] = (frequencyMap[result] ?? 0) + 1;
      }

      const double expectedCountPerValue = numberOfRolls / possibilities;
      const double tolerance = 0.01; // 1%

      frequencyMap.forEach((value, count) {
        const lowerBound = expectedCountPerValue * (1 - tolerance);
        const upperBound = expectedCountPerValue * (1 + tolerance);
        expect(
          count.toDouble(),
          inInclusiveRange(lowerBound, upperBound),
          reason:
          'Wynik $value wystąpił $count razy, co nie mieści się w zakresie '
              '$lowerBound - $upperBound przy $numberOfRolls rzutach.',
        );
      });
    },
  );
  test(
    'Sprawdza czy getRandomValue losuje wartości zbliżone do równomiernego rozkładu dla drugiego rzutu',
        () {
      const int numberOfRolls = 10000000;
      const int possibilities = 6;
      final Map<int, int> frequencyMap = {};

      for (int i = 0; i < numberOfRolls; i++) {
        if (GamePageController.getRandomValue(possibilities, null) == 6) {
          final result = GamePageController.getRandomValue(possibilities, null);
          frequencyMap[result] = (frequencyMap[result] ?? 0) + 1;
        } else {
          i--;
        }
      }

      const double expectedCountPerValue = numberOfRolls / possibilities;
      const double tolerance = 0.01; // 1%

      frequencyMap.forEach((value, count) {
        const lowerBound = expectedCountPerValue * (1 - tolerance);
        const upperBound = expectedCountPerValue * (1 + tolerance);
        expect(
          count.toDouble(),
          inInclusiveRange(lowerBound, upperBound),
          reason:
          'Wynik $value wystąpił $count razy, co nie mieści się w zakresie '
              '$lowerBound - $upperBound przy $numberOfRolls rzutach.',
        );
      });
    },
  );
}
