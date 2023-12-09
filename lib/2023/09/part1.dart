import 'dart:convert';
import 'dart:io';

void main() {
  final File file = File('lib/2023/09/input.txt');
  int total = 0;

  file.openRead().transform(utf8.decoder).transform(LineSplitter()).listen(
        (event) => total += getExtrapolatedValue(event),
        onDone: () => print(total),
      );
}

int getExtrapolatedValue(String s) {
  List<int> numbers = s.split(' ').map((number) => int.parse(number)).toList();
  List<int> lastNumbers = [];

  while (!numbers.every((number) => number == 0)) {
    lastNumbers.add(numbers[numbers.length - 1]);

    numbers = numbers.fold(<int>[], (previousValue, element) {
      if (previousValue.isEmpty) return [0];

      int value = element - numbers[previousValue.length - 1];
      previousValue.add(value);

      return previousValue;
    }).sublist(1);
  }
  return lastNumbers.reduce((value, element) => value + element);
}
