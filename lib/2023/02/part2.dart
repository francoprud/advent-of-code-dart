import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main() {
  final File file = File('lib/2023/02/input.txt');
  int powerSum = 0;

  file.openRead().transform(utf8.decoder).transform(LineSplitter()).listen(
    (event) {
      final List<int> gameConfiguration = getGameConfiguration(event);

      powerSum += getColorsPowerSum(gameConfiguration);
    },
    onDone: () => print(powerSum),
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

int getColorsPowerSum(List<int> gameConfiguration) {
  return gameConfiguration.getRange(1, 4).reduce((value, element) => value * element);
}
