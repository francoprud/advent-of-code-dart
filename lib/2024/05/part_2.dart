import 'dart:io';

void main() =>
    print(SafetyManual.new('lib/2024/05/input.txt').countCorrectUpdates());

class SafetyManual {
  late Map<int, Set<int>> rules;
  late List<List<int>> updates;

  SafetyManual(String filename) {
    final ({Map<int, Set<int>> rules, List<List<int>> updates}) config =
        _getConfig(filename);

    this.rules = config.rules;
    this.updates = config.updates;
  }

  int countCorrectUpdates() {
    int sum = 0;

    for (List<int> update in updates) {
      if (!_isCorrect(update)) {
        final fixedUpdate = fixUpdate(update);

        sum += fixedUpdate[(fixedUpdate.length - 1) ~/ 2];
      }
    }

    return sum;
  }

  List<int> fixUpdate(List<int> update) {
    List<int> fixed = List.from(update);

    for (int i = 0; i < fixed.length - 1; i++) {
      for (int j = i + 1; j < fixed.length; j++) {
        if ((rules[fixed[j]] ?? {}).contains(fixed[i])) {
          int temp = fixed[i];
          fixed[i] = fixed[j];
          fixed[j] = temp;
        }
      }
    }

    return fixed;
  }

  bool _isCorrect(List<int> update) {
    Set<int> notPossibleValues = {};

    for (int i = update.length - 1; i >= 0; i--) {
      if (notPossibleValues.contains(update[i])) return false;

      notPossibleValues.addAll(rules[update[i]] ?? {});
    }

    return true;
  }

  ({Map<int, Set<int>> rules, List<List<int>> updates}) _getConfig(
      String filename) {
    Map<int, Set<int>> rules = {};
    List<List<int>> updates = [];
    bool isRule = true;

    for (final line in File(filename).readAsLinesSync()) {
      if (line.isEmpty) {
        isRule = false;
        continue;
      }

      if (isRule) {
        final parts = line.split('|');
        final left = int.parse(parts[0]);
        final right = int.parse(parts[1]);

        rules.putIfAbsent(left, () => {}).add(right);
      } else {
        updates.add(line.split(',').map(int.parse).toList());
      }
    }

    return (
      rules: rules,
      updates: updates,
    );
  }
}
