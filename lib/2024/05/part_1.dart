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
    int correct = 0;

    for (List<int> update in updates) {
      if (_isCorrect(update)) correct += update[(update.length - 1) ~/ 2];
    }

    return correct;
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
