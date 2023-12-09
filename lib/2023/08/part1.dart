import 'dart:io';

void main() {
  ({List<String> moves, Map<String, List<String>> map}) mapConfiguration =
      parseMapConfiguration();
  String currentStep = 'AAA';
  int i = 0, totalSteps = 1;

  while (true) {
    int move = mapConfiguration.moves[i] == 'L' ? 0 : 1;
    currentStep = mapConfiguration.map[currentStep]![move];

    if (currentStep == 'ZZZ') {
      print(totalSteps);
      return;
    }

    totalSteps++;
    i = (i + 1) % mapConfiguration.moves.length;
  }
}

({List<String> moves, Map<String, List<String>> map}) parseMapConfiguration() {
  List<String> lines = File('lib/2023/08/input.txt').readAsLinesSync();
  Map<String, List<String>> map = {};

  for (int i = 2; i < lines.length; i++) {
    List<String> values = parseLine(lines[i]);

    map.putIfAbsent(values[0], () => [values[1], values[2]]);
  }

  return (moves: lines[0].split(''), map: map);
}

List<String> parseLine(String line) {
  return [
    line.substring(0, 3),
    line.substring(7, 10),
    line.substring(12, 15),
  ];
}
