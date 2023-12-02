import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main() {
  final File file = File('lib/2023/02/input.txt');
  final List<int> availableColors = [12, 13, 14];
  int possibleGameIdsSum = 0;

  file.openRead().transform(utf8.decoder).transform(LineSplitter()).listen(
    (event) {
      final List<int> gameConfiguration = getGameConfiguration(event);

      if (isGamePossible(availableColors, gameConfiguration)) {
        possibleGameIdsSum += gameConfiguration[0];
      }
    },
    onDone: () => print(possibleGameIdsSum),
  );
}

// returns the configurations with the following format: [id, red, green, blue]
List<int> getGameConfiguration(String s) {
  return [
    getIdFromGameRecord(s),
    getColorFromGameRecord(s, 'red'),
    getColorFromGameRecord(s, 'green'),
    getColorFromGameRecord(s, 'blue')
  ];
}

int getIdFromGameRecord(String s) {
  RegExp exp = RegExp(r'Game (\d*)');

  return int.parse(exp.firstMatch(s)!.group(1)!);
}

int getColorFromGameRecord(String s, String color) {
  RegExp exp = RegExp('(\\d*) $color');

  return exp.allMatches(s).map((match) => int.parse(match[1]!)).reduce(max);
}

bool isGamePossible(List<int> availableColors, List<int> gameConfiguration) {
  return availableColors[0] >= gameConfiguration[1] &&
      availableColors[1] >= gameConfiguration[2] &&
      availableColors[2] >= gameConfiguration[3];
}
