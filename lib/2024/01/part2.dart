import 'dart:io';
import 'package:collection/collection.dart';

void main() {
  final ({List<int> left, List<int> right}) locationsLists =
      parseLocationsLists();

  print(
      calculateListsSimilarityScore(locationsLists.left, locationsLists.right));
}

({List<int> left, List<int> right}) parseLocationsLists() {
  final List<List<int>> lines = File('lib/2024/01/input.txt')
      .readAsLinesSync()
      .map((e) => e.split('   ').map((e) => int.parse(e)).toList())
      .toList();

  return (
    left: lines.map((line) => line[0]).toList(),
    right: lines.map((line) => line[1]).toList()
  );
}

int calculateListsSimilarityScore(List<int> left, List<int> right) {
  final Map<int, int> rightFrequency = right
      .groupListsBy((number) => number)
      .map((key, value) => MapEntry(key, value.length));

  return left
      .map((number) => (rightFrequency[number] ?? 0) * number)
      .reduce((sum, value) => sum + value);
}
