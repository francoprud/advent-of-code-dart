import 'dart:convert';
import 'dart:io';
import 'package:quiver/iterables.dart';

void main() {
  List<List<String>> currentPattern = [];
  int totalSummarizedReflections = 0;

  File('lib/2023/13/input.txt')
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .listen(
    (event) {
      List<String> line = parseLine(event);
      if (isLineEmpty(line)) {
        totalSummarizedReflections += calculateReflection(currentPattern);
        currentPattern = [];
      } else {
        currentPattern.add(line);
      }
    },
    onDone: () => print(totalSummarizedReflections),
  );
}

List<String> parseLine(String s) {
  return s.split('').toList();
}

bool isLineEmpty(List<String> line) {
  return line.every((element) => element == ' ');
}

int calculateReflection(List<List<String>> currentPattern) {
  return getSymmetricalHorizontalReflection(currentPattern) * 100 +
      getSymmetricalVerticalReflection(currentPattern);
}

int getSymmetricalHorizontalReflection(List<List<String>> pattern) {
  for (int i = 1; i < pattern.length; i++) {
    List<List<String>> topPattern = pattern.sublist(0, i).reversed.toList();
    List<List<String>> bottomPattern = pattern.sublist(i, pattern.length);

    topPattern = topPattern.take(bottomPattern.length).toList();
    bottomPattern = bottomPattern.take(topPattern.length).toList();

    if (topPattern.toString() == bottomPattern.toString()) return i;
  }

  return 0;
}

int getSymmetricalVerticalReflection(List<List<String>> pattern) {
  return getSymmetricalHorizontalReflection(zip(pattern).toList());
}
