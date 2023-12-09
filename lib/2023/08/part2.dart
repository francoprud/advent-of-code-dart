import 'dart:io';

void main() {
  ({
    List<String> moves,
    List<String> startingNodes,
    Map<String, List<String>> map
  }) mapConfiguration = parseMapConfiguration();
  List<int> nodesTotalSteps = [];

  mapConfiguration.startingNodes.forEach((node) {
    nodesTotalSteps.add(getTotalStepsToEndingNode(mapConfiguration, node));
  });

  print(nodesTotalSteps
      .reduce((value, element) => leastCommonMultiple(value, element)));
}

({List<String> moves, List<String> startingNodes, Map<String, List<String>> map})
    parseMapConfiguration() {
  List<String> lines = File('lib/2023/08/input.txt').readAsLinesSync();
  List<String> startingNodes = [];
  Map<String, List<String>> map = {};

  for (int i = 2; i < lines.length; i++) {
    List<String> values = parseLine(lines[i]);

    if (isStartingNode(values[0])) startingNodes.add(values[0]);

    map.putIfAbsent(values[0], () => [values[1], values[2]]);
  }

  return (moves: lines[0].split(''), startingNodes: startingNodes, map: map);
}

List<String> parseLine(String line) {
  return [
    line.substring(0, 3),
    line.substring(7, 10),
    line.substring(12, 15),
  ];
}

int getTotalStepsToEndingNode(
    ({
      List<String> moves,
      List<String> startingNodes,
      Map<String, List<String>> map
    }) mapConfiguration,
    String node) {
  String currentStep = node;
  int i = 0, totalSteps = 1;

  while (true) {
    int move = mapConfiguration.moves[i] == 'L' ? 0 : 1;
    currentStep = mapConfiguration.map[currentStep]![move];

    if (isEndingNode(currentStep)) break;

    totalSteps++;
    i = (i + 1) % mapConfiguration.moves.length;
  }

  return totalSteps;
}

bool isStartingNode(String s) {
  return s[s.length - 1] == 'A';
}

bool isEndingNode(String s) {
  return s[s.length - 1] == 'Z';
}

int leastCommonMultiple(int a, int b) {
  if ((a == 0) || (b == 0)) {
    return 0;
  }

  return ((a ~/ a.gcd(b)) * b).abs();
}
