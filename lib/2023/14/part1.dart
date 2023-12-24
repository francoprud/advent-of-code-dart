import 'dart:io';

void main() {
  Board board = Board('lib/2023/14/input.txt');

  board.tiltNorth();
  print(board.calculateTotalLoad());
}

class Board {
  late List<List<String>> layout;

  Board(String filename) {
    this.layout = _getLayout(filename);
  }

  List<List<String>> _getLayout(String filename) =>
      File(filename).readAsLinesSync().map((line) => line.split('')).toList();

  void tiltNorth() {
    for (int column = 0; column < layout[0].length; column++) {
      int? availableSpace = null;
      for (int row = 0; row < layout.length; row++) {
        if (layout[row][column] == 'O') {
          if (availableSpace != null) {
            layout[row][column] = '.';
            layout[availableSpace][column] = 'O';
            availableSpace = _advanceAvailableSpace(availableSpace + 1, column);
          }
        } else if (layout[row][column] == '.') {
          if (availableSpace == null) availableSpace = row;
        } else {
          availableSpace = null;
        }
      }
    }
  }

  int? _advanceAvailableSpace(int availableSpace, int column) {
    for (int row = availableSpace; row < layout.length; row++) {
      if (layout[row][column] == '.') {
        return row;
      } else if (layout[row][column] == '#') return null;
    }

    return null;
  }

  int calculateTotalLoad() {
    int totalLoad = 0;

    for (int i = 0; i < layout.length; i++) {
      for (int j = 0; j < layout[i].length; j++) {
        if (layout[i][j] == 'O') totalLoad += (layout.length - i);
      }
    }

    return totalLoad;
  }

  void show() {
    for (List<String> row in layout) print(row.join(''));
  }
}
