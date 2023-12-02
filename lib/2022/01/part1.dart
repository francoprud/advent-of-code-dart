import 'dart:convert';
import 'dart:io';

void main() {
  final File file = File('lib/2022/01/input.txt');

  int caloriesMax = 0, caloriesCount = 0;

  file.openRead().transform(utf8.decoder).transform(LineSplitter()).listen(
    (event) {
      if (event.isEmpty) {
        caloriesCount = 0;
      } else {
        final int calories = int.parse(event);

        caloriesCount += calories;

        if (caloriesMax < caloriesCount) {
          caloriesMax = caloriesCount;
        }
      }
    },
    onDone: () => print(caloriesMax),
  );
}
