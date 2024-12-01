import 'dart:io';

void main() {
  final locationsLists = parseLocationsLists();
  print(calculateListsDistance(
    left: locationsLists.left,
    right: locationsLists.right,
  ));
}

({List<int> left, List<int> right}) parseLocationsLists() {
  final List<List<int>> lines = File('lib/2024/01/input.txt')
      .readAsLinesSync()
      .map((line) => line.split('   ').map(int.parse).toList())
      .toList();

  return (
    left: lines.map((line) => line[0]).toList(),
    right: lines.map((line) => line[1]).toList(),
  );
}

int calculateListsDistance({
  required List<int> left,
  required List<int> right,
}) {
  final sortedLeft = List<int>.from(left)..sort();
  final sortedRight = List<int>.from(right)..sort();

  return List.generate(
    sortedLeft.length,
    (i) => (sortedLeft[i] - sortedRight[i]).abs(),
  ).reduce((sum, value) => sum + value);
}
