import 'dart:collection';
import 'dart:io';
import 'dart:math';

void main() {
  List<List<String>> board = getBoard('lib/2023/10/input.txt');
  Point<int> startingPosition = getStartingPosition(board);
  Queue<Point<int>> queue = Queue<Point<int>>.from([startingPosition]);
  Set<Point<int>> visited = {};

  while (queue.isNotEmpty) {
    Point<int> currentPosition = queue.removeFirst();
    visited.add(currentPosition);

    List<Point<int>> possibleMoves = getPossibleMoves(board, currentPosition);
    for (Point<int> move in possibleMoves) {
      if (!visited.contains(move)) {
        queue.add(move);
      }
    }
  }

  print(visited.length ~/ 2);
}

List<List<String>> getBoard(String filename) {
  return File(filename).readAsLinesSync().map((line) => line.split('')).toList();
}

Point<int> getStartingPosition(List<List<String>> board) {
  for (int row = 0; row < board.length; row++) {
    for (int column = 0; column < board[row].length; column++) {
      if (board[row][column] == 'S') return Point<int>(row, column);
    }
  }

  throw Exception('No starting position found');
}

List<Point<int>> getPossibleMoves(List<List<String>> board, Point<int> position) {
  List<Point<int>> possibleMoves = [];
  String tile = board[position.x][position.y];

  // going up: tile must be S, |, J or L, and the tile above must be |, 7 or F
  if (position.x > 0 &&
      '|SJL'.contains(tile) &&
      '|7F'.contains(board[position.x - 1][position.y])) {
    possibleMoves.add(Point<int>(position.x - 1, position.y));
  }

  // going down: tile must be S, |, 7 or F, and the tile below must be |, J or L
  if (position.x < board.length - 1 &&
      '|S7F'.contains(tile) &&
      '|JL'.contains(board[position.x + 1][position.y])) {
    possibleMoves.add(Point<int>(position.x + 1, position.y));
  }

  // going left: tile must be S, -, 7 or J, and the tile to the left must be -, L or F
  if (position.y > 0 &&
      '-S7J'.contains(tile) &&
      '-LF'.contains(board[position.x][position.y - 1])) {
    possibleMoves.add(Point<int>(position.x, position.y - 1));
  }

  // going right: tile must be S, -, F or L, and the tile to the right must be -, J or 7
  if (position.y < board[position.x].length - 1 &&
      '-SFL'.contains(tile) &&
      '-J7'.contains(board[position.x][position.y + 1])) {
    possibleMoves.add(Point<int>(position.x, position.y + 1));
  }

  return possibleMoves;
}
