import 'dart:convert';
import 'dart:io';

List<int> _times = [];
List<int> _distances = [];

void main() {
  final File file = File('lib/2023/06/input.txt');
  List<int> totalMarginOfError = [];

  file.openRead().transform(utf8.decoder).transform(LineSplitter()).listen(
    (event) => parseLine(event),
    onDone: () {
      for (int i = 0; i < _times.length; i++) {
        int winningWays = 0;

        for (int j = 1; j < _times[i]; j++) {
          if (j * (_times[i] - j) > _distances[i]) winningWays += 1;
        }

        totalMarginOfError.add(winningWays);
      }

      print(totalMarginOfError.reduce((value, element) => value * element));
    },
  );
}

void parseLine(String s) {
  List<int> numbers = getNumbers(s);

  if (s.contains('Time')) {
    _times = numbers;
  } else {
    _distances = numbers;
  }
}

List<int> getNumbers(String s) {
  return s
      .split(':')[1]
      .trim()
      .split(' ')
      .map((num) => int.tryParse(num))
      .whereType<int>()
      .toList();
}
