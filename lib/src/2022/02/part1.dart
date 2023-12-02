import 'dart:convert';
import 'dart:io';

final Map<String, String> _strategyGuide = {'X': 'A', 'Y': 'B', 'Z': 'C'};
final Map<String, String> _winningRules = {'A': 'C', 'B': 'A', 'C': 'B'};
final Map<String, int> _scores = {'A': 1, 'B': 2, 'C': 3};

// A for Rock, B for Paper, and C for Scissors
// X for Rock, Y for Paper, and Z for Scissors
void main() {
  final File file = File('lib/src/2022/02/input.txt');
  int strategyScore = 0;

  file.openRead().transform(utf8.decoder).transform(LineSplitter()).listen(
    (event) {
      final List<String> moves = getMoves(event);

      strategyScore += calculateScore(moves);
    },
    onDone: () => print(strategyScore),
  );
}

List<String> getMoves(event) {
  final List<String> moves = event.split(' ');
  final String decryptedMove = _strategyGuide[moves[1]]!;

  return [moves[0], decryptedMove];
}

int calculateScore(moves) {
  int score = 0;

  if (moves[0] == moves[1]) {
    score += 3;
  } else if (_winningRules[moves[1]] == moves[0]) {
    score += 6;
  }

  return score + _scores[moves[1]]!;
}
