import 'dart:convert';
import 'dart:io';

void main() {
  final File file = File('lib/src/2022/01/input.txt');
  final caloriesElves = <int>[];
  int caloriesCount = 0;

  file.openRead().transform(utf8.decoder).transform(LineSplitter()).listen(
    (event) {
      if (event.isEmpty) {
        caloriesElves.add(caloriesCount);
        caloriesCount = 0;
      } else {
        final int calories = int.parse(event);

        caloriesCount += calories;
      }
    },
    onDone: () {
      caloriesElves.sort((a, b) => b - a);
      print(caloriesElves.take(3).reduce((value, element) => value + element));
    },
  );
}
