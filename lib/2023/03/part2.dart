import 'dart:io';
import 'dart:math';

void main() {
  final File file = File('lib/2023/03/input.txt');
  List<List<String>> matrix = getEngineSchematicAsMatrix(file);
  List<int> numbers = [];
  int gearRatioSum = 0;

  for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[i].length; j++) {
      if (matrix[i][j] == '*') {
        numbers = findAdjacentNumbers(matrix, i, j);

        if (numbers.length == 2) {
          gearRatioSum += numbers.reduce((value, element) => value * element);
        }
      }
    }
  }

  print(gearRatioSum);
}

List<List<String>> getEngineSchematicAsMatrix(File file) {
  return file.readAsLinesSync().map((line) => line.split('')).toList();
}

List<int> findAdjacentNumbers(List<List<String>> matrix, int i, int j) {
  List<int> numbers = [];
  Set<Point> uniqueCoordinates = Set();

  for (int row = i - 1; row <= i + 1; row++) {
    for (int column = j - 1; column <= j + 1; column++) {
      (int, Point)? numberWithCoordinate =
          findNumberFromCoordinate(matrix, row, column);

      if (numberWithCoordinate != null) {
        if (!uniqueCoordinates.contains(numberWithCoordinate.$2)) {
          numbers.add(numberWithCoordinate.$1);
          uniqueCoordinates.add(numberWithCoordinate.$2);
        }
      }
    }
  }

  return numbers;
}

(int, Point)? findNumberFromCoordinate(
    List<List<String>> matrix, int i, int j) {
  if (!belongsToMatrix(matrix, i, j)) return null;
  if (!isInt(matrix[i][j])) return null;

  String partialNumber = matrix[i][j];
  int startingColumn = j;

  for (int column = j - 1; column >= 0; column--) {
    if (!isInt(matrix[i][column])) break;

    partialNumber = matrix[i][column] + partialNumber;
    startingColumn = column;
  }

  for (int column = j + 1; column < matrix[i].length; column++) {
    if (!isInt(matrix[i][column])) break;

    partialNumber = partialNumber + matrix[i][column];
  }

  return (int.parse(partialNumber), Point(i, startingColumn));
}

bool isInt(String s) {
  return int.tryParse(s) != null;
}

bool belongsToMatrix(matrix, i, j) {
  return i >= 0 && i < matrix.length && j >= 0 && j <= matrix[i].length;
}

bool isSymbol(String s) {
  return s != '.' && !isInt(s);
}
