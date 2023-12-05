import 'dart:convert';
import 'dart:io';

void main() {
  final File file = File('lib/2023/01/input.txt');
  int coordinatesSum = 0;

  file.openRead().transform(utf8.decoder).transform(LineSplitter()).listen(
        (event) => coordinatesSum += getCoordinate(getNumbersFromString(event)),
        onDone: () => print(coordinatesSum),
      );
}

String getNumbersFromString(String s) {
  final Map<String, String> conversion = {
    'one': '1',
    'two': '2',
    'three': '3',
    'four': '4',
    'five': '5',
    'six': '6',
    'seven': '7',
    'eight': '8',
    'nine': '9',
  };
  final RegExp regExp = RegExp('(?=(1|2|3|4|5|6|7|8|9|one|two|three|four|five|six|seven|eight|nine))');

  return regExp.allMatches(s).map((match) {
    final String? number = match[1];

    return conversion[number] ?? number;
  }).join('');
}

int getCoordinate(String s) {
  return int.parse('${s[0]}${s[s.length - 1]}');
}
