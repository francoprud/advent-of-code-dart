import 'dart:convert';
import 'dart:io';

void main() {
  final File file = File('lib/src/2022/03/input.txt');
  int prioritiesSum = 0;
  int eventsCount = 0;
  List<String> events = [];

  file.openRead().transform(utf8.decoder).transform(LineSplitter()).listen(
    (event) {
      eventsCount++;
      events.add(event);

      if (eventsCount % 3 == 0) {
        prioritiesSum += calculateItemPriority(getBadge(events));
        eventsCount = 0;
        events = [];
      }
    },
    onDone: () => print(prioritiesSum),
  );
}

String? getBadge(List<String> events) {
  for (int i = 0; i <= events[0].length; i++) {
    String char = events[0][i];

    if (events[1].contains(char) && events[2].contains(char)) return char;
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
