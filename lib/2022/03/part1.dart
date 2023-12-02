import 'dart:convert';
import 'dart:io';

void main() {
  final File file = File('lib/2022/03/input.txt');
  int prioritiesSum = 0;

  file.openRead().transform(utf8.decoder).transform(LineSplitter()).listen(
        (event) => prioritiesSum += calculateItemPriority(getMixedItem(event)),
        onDone: () => print(prioritiesSum),
      );
}

String? getMixedItem(s) {
  List<String> compartments = splitByHalf(s);

  for (int i = 0; i <= compartments[0].length; i++) {
    String char = compartments[0][i];

    if (compartments[1].contains(char)) return char;
  }

  throw ArgumentError('No matching items.');
}

List<String> splitByHalf(String s) {
  final int halfLength = s.length ~/ 2;

  return [s.substring(0, halfLength), s.substring(halfLength)];
}

int calculateItemPriority(item) {
  final int codeUnit = item.codeUnitAt(0);

  if (codeUnit >= 'a'.codeUnitAt(0) && codeUnit <= 'z'.codeUnitAt(0)) {
    return codeUnit - 'a'.codeUnitAt(0) + 1;
  } else if (codeUnit >= 'A'.codeUnitAt(0) && codeUnit <= 'Z'.codeUnitAt(0)) {
    return codeUnit - 'A'.codeUnitAt(0) + 27;
  } else {
    throw ArgumentError('Item not between the proper characters.');
  }
}
