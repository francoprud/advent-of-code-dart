import 'dart:convert';
import 'dart:io';

void main() {
  final File file = File('lib/src/2023/01/input.txt');
  int coordinatesSum = 0;

  file.openRead().transform(utf8.decoder).transform(LineSplitter()).listen(
        (event) => coordinatesSum += getCoordinate(getNumbersFromString(event)),
        onDone: () => print(coordinatesSum),
      );
}

String getNumbersFromString(String s) {
  return s.replaceAll(RegExp('[^0-9]'), '');
}

int getCoordinate(String s) {
  return int.parse('${s[0]}${s[s.length - 1]}');
}
