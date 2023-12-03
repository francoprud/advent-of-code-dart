import 'dart:io';

void main() {
  final File file = File('lib/2023/03/input.txt');
  List<List<String>> matrix = getEngineSchematicAsMatrix(file);
  int partsSum = 0;

  for (int i = 0; i < matrix.length; i++) {
    String partialNumber = '';
    List<int?> partialNumberCoordinates = [null, null];

    for (int j = 0; j < matrix[i].length; j++) {
      if (isInt(matrix[i][j])) {
        if (partialNumber.isEmpty) partialNumberCoordinates[0] = j;
        partialNumber += matrix[i][j];
      }

      // if the partialNumber is over by one of these 2 ways:
      // 1. the current char is not a number
      // 2. the current position is the end of the matrix
      if ((!isInt(matrix[i][j]) || j == matrix[i].length - 1)) {
        if (partialNumber.isNotEmpty) {
          partialNumberCoordinates[1] = j - 1;
          if (isPartNumber(matrix, i, partialNumberCoordinates)) {
            partsSum += int.parse(partialNumber);
          }
          partialNumber = '';
          partialNumberCoordinates = [null, null];
        }
      }
    }
  }

  print(partsSum);
}

List<List<String>> getEngineSchematicAsMatrix(File file) {
  return file.readAsLinesSync().map((line) => line.split('')).toList();
}

bool isInt(String s) {
  return int.tryParse(s) != null;
}

bool isPartNumber(matrix, line, coordinates) {
  for (int i = line - 1; i <= line + 1; i++) {
    for (int j = coordinates[0] - 1; j <= coordinates[1] + 1; j++) {
      if (belongsToMatrix(matrix, i, j) && isSymbol(matrix[i][j])) {
        return true;
      }
    }
  }

  return false;
}

bool belongsToMatrix(matrix, i, j) {
  return i >= 0 && i < matrix.length && j >= 0 && j <= matrix[i].length;
}

bool isSymbol(String s) {
  return s != '.' && !isInt(s);
}
