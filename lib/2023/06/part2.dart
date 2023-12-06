import 'dart:convert';
import 'dart:io';

int time = 0, distance = 0;

void main() {
  final File file = File('lib/2023/06/input.txt');

  file.openRead().transform(utf8.decoder).transform(LineSplitter()).listen(
    (event) => parseLine(event),
    onDone: () {
      int winningWays = 0;

      for (int j = 1; j < time; j++) {
        if (j * (time - j) > distance) winningWays += 1;
      }

      print(winningWays);
    },
  );
}

void parseLine(String s) {
  int numbers = getNumber(s);

  if (s.contains('Time')) {
    time = numbers;
  } else {
    distance = numbers;
  }
}

int getNumber(String s) {
  return int.parse(s.split(':')[1].replaceAll(' ', ''));
}
