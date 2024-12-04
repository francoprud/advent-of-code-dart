import 'dart:io';
import 'dart:math';

void main() => print(_countXMasOccurrences('lib/2024/04/input.txt'));

int _countXMasOccurrences(String path) {
  List<List<String>> puzzle = _getPuzzle(path);
  int occurrences = 0;

  for (int i = 0; i < puzzle.length; i++) {
    for (int j = 0; j < puzzle[i].length; j++) {
      if (puzzle[i][j] == 'A') {
        occurrences += _countOccurrancesForPosition(puzzle, Point<int>(i, j));
      }
    }
  }

  return occurrences;
}

List<List<String>> _getPuzzle(String filename) =>
    File(filename).readAsLinesSync().map((line) => line.split('')).toList();

int _countOccurrancesForPosition(
    List<List<String>> puzzle, Point<int> position) {
  const List<Point<int>> directions = [
    Point(-1, -1),
    Point(-1, 1),
    Point(1, 1),
    Point(1, -1),
  ];
  const Set<String> validPatterns = {'MSSM', 'MMSS', 'SMMS', 'SSMM'};

  final pattern = directions.map((direction) {
    final Point<int> currentPosition = position + direction;
    return _isValidPosition(puzzle, currentPosition)
        ? puzzle[currentPosition.x][currentPosition.y]
        : '';
  }).join();

  return validPatterns.contains(pattern) ? 1 : 0;
}

bool _isValidPosition(List<List<String>> puzzle, Point<int> position) {
  return position.x >= 0 &&
      position.x < puzzle.length &&
      position.y >= 0 &&
      position.y < puzzle[position.x].length;
}
