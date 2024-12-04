import 'dart:io';
import 'dart:math';

void main() {
  print(_countOccurrences('lib/2024/04/input.txt', 'XMAS'));
}

int _countOccurrences(String path, String word) {
  List<List<String>> puzzle = _getPuzzle(path);
  int occurrences = 0;

  for (int i = 0; i < puzzle.length; i++) {
    for (int j = 0; j < puzzle[i].length; j++) {
      if (puzzle[i][j] == word[0]) {
        occurrences +=
            _countOccurrancesForPosition(puzzle, Point<int>(i, j), word);
      }
    }
  }

  return occurrences;
}

List<List<String>> _getPuzzle(String filename) =>
    File(filename).readAsLinesSync().map((line) => line.split('')).toList();

int _countOccurrancesForPosition(
    List<List<String>> puzzle, Point<int> position, String word) {
  final List<Point<int>> directions = [
    for (var x = -1; x <= 1; x++)
      for (var y = -1; y <= 1; y++)
        if (x != 0 || y != 0) Point(x, y)
  ];

  return directions
      .map((dir) => _checkWordInDirection(puzzle, position, word, dir))
      .reduce((sum, value) => sum + value);
}

int _checkWordInDirection(List<List<String>> puzzle, Point<int> position,
    String word, Point<int> direction) {
  if (!_satisfiesBounds(puzzle, position, word.length, direction)) return 0;

  Point<int> currentPosition = position;

  for (int k = 0; k < word.length; k++) {
    if (!_isValidPosition(puzzle, currentPosition)) return 0;
    if (puzzle[currentPosition.x][currentPosition.y] != word[k]) return 0;

    currentPosition += direction;
  }

  return 1;
}

bool _isValidPosition(List<List<String>> puzzle, Point<int> position) {
  return position.x >= 0 &&
      position.x < puzzle.length &&
      position.y >= 0 &&
      position.y < puzzle[position.x].length;
}

bool _satisfiesBounds(List<List<String>> puzzle, Point<int> position,
    int length, Point<int> direction) {
  Point<int> lastPosition = position + direction * (length - 1);

  return _isValidPosition(puzzle, lastPosition);
}
