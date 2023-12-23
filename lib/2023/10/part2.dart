import 'dart:collection';
import 'dart:io';
import 'dart:math';

void main() {
  Maze maze = Maze('lib/2023/10/input.txt');

  maze.findLoop();
  maze.replaceStartingPositionTile();
  maze.cleanBoardFromUnusedPipes(); // avoids me checking if a pipe tile is part of the loop or not
  print(maze.countInsideTiles());
}

class Maze {
  late List<List<String>> board;
  late Point<int> startingPosition;
  Set<String> possibleStartingPositionValues = {'-', '|', '7', 'J', 'L', 'F'};
  Set<Point<int>> visited = {};

  Maze(String filename) {
    this.board = _getBoard(filename);
    this.startingPosition = _getStartingPosition();
  }

  List<List<String>> _getBoard(String filename) =>
      File(filename).readAsLinesSync().map((line) => line.split('')).toList();

  Point<int> _getStartingPosition() {
    for (int row = 0; row < board.length; row++) {
      for (int column = 0; column < board[row].length; column++) {
        if (board[row][column] == 'S') return Point<int>(row, column);
      }
    }

    throw Exception('No starting position found');
  }

  void findLoop() {
    Queue<Point<int>> queue = Queue<Point<int>>.from([startingPosition]);

    while (queue.isNotEmpty) {
      Point<int> currentPosition = queue.removeFirst();
      visited.add(currentPosition);

      List<Point<int>> possibleMoves = getPossibleMoves(currentPosition);
      for (Point<int> move in possibleMoves) {
        if (!visited.contains(move)) {
          queue.add(move);
        }
      }
    }
  }

  void replaceStartingPositionTile() {
    if (possibleStartingPositionValues.length == 1) {
      board[startingPosition.x][startingPosition.y] =
          possibleStartingPositionValues.first;
    }
  }

  List<Point<int>> getPossibleMoves(Point<int> position) {
    List<Point<int>> possibleMoves = [];
    String tile = board[position.x][position.y];

    // going up: tile must be S, |, J or L, and the tile above must be |, 7 or F
    if (position.x > 0 &&
        '|SJL'.contains(tile) &&
        '|7F'.contains(board[position.x - 1][position.y])) {
      possibleMoves.add(Point<int>(position.x - 1, position.y));

      if (tile == 'S') {
        possibleStartingPositionValues =
            possibleStartingPositionValues.intersection({'|', 'J', 'L'});
      }
    }

    // going down: tile must be S, |, 7 or F, and the tile below must be |, J or L
    if (position.x < board.length - 1 &&
        '|S7F'.contains(tile) &&
        '|JL'.contains(board[position.x + 1][position.y])) {
      possibleMoves.add(Point<int>(position.x + 1, position.y));

      if (tile == 'S') {
        possibleStartingPositionValues =
            possibleStartingPositionValues.intersection({'|', '7', 'F'});
      }
    }

    // going left: tile must be S, -, 7 or J, and the tile to the left must be -, L or F
    if (position.y > 0 &&
        '-S7J'.contains(tile) &&
        '-LF'.contains(board[position.x][position.y - 1])) {
      possibleMoves.add(Point<int>(position.x, position.y - 1));

      if (tile == 'S') {
        possibleStartingPositionValues =
            possibleStartingPositionValues.intersection({'-', '7', 'J'});
      }
    }

    // going right: tile must be S, -, F or L, and the tile to the right must be -, J or 7
    if (position.y < board[position.x].length - 1 &&
        '-SFL'.contains(tile) &&
        '-J7'.contains(board[position.x][position.y + 1])) {
      possibleMoves.add(Point<int>(position.x, position.y + 1));

      if (tile == 'S') {
        possibleStartingPositionValues =
            possibleStartingPositionValues.intersection({'-', 'F', 'L'});
      }
    }

    return possibleMoves;
  }

  void cleanBoardFromUnusedPipes() {
    for (int row = 0; row < board.length; row++) {
      for (int column = 0; column < board[row].length; column++) {
        Point<int> position = Point<int>(row, column);
        if (!visited.contains(position)) {
          board[row][column] = '.';
        }
      }
    }
  }

  int countInsideTiles() {
    int counter = 0;

    for (int row = 0; row < board.length; row++) {
      for (int column = 0; column < board[row].length; column++) {
        if (!visited.contains(Point<int>(row, column))) {
          int inversions = _countEdgeCrossings(row, column);
          if (inversions % 2 == 1) {
            counter++;
          }
        }
      }
    }

    return counter;
  }

  // going to the left
  int _countEdgeCrossings(int row, int column) {
    int counter = 0;

    for (int i = 0; i < column; i++) if ('JL|'.contains(board[row][i])) counter++;

    return counter;
  }

  void show() {
    for (List<String> row in board) {
      print(row.join(''));
    }
  }
}
