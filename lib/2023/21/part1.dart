import 'dart:collection';
import 'dart:io';
import 'dart:math';

void main() {
  Puzzle puzzle = Puzzle.build('lib/2023/21/input.txt');
  print(puzzle.totalReachableGardenPlots(64));
}

class Puzzle {
  List<List<String>> map = [];

  Puzzle({required this.map});

  factory Puzzle.build(String filename) {
    List<List<String>> map =
        File(filename).readAsLinesSync().map((line) => line.split('')).toList();

    return Puzzle(map: map);
  }

  int totalReachableGardenPlots(int desiredSteps) {
    Set<({Point<int> position, int steps})> visitedGardenPlots = {};
    Set<Point<int>> finalGardenPlots = {};
    Queue<({Point<int> position, int steps})> queue = Queue();
    queue.add((position: _getStartingPoint(), steps: 0));

    while (queue.isNotEmpty) {
      var current = queue.removeFirst();

      if (visitedGardenPlots.contains(current)) continue;

      visitedGardenPlots.add((position: current.position, steps: current.steps));

      if (current.steps == desiredSteps) {
        finalGardenPlots.add(current.position);
        continue;
      }

      List<Point<int>> nextSteps = _getPossibleNextSteps(current.position);

      for (Point<int> nextStep in nextSteps) {
        queue.add((position: nextStep, steps: current.steps + 1));
      }
    }
    _show(finalGardenPlots);
    return finalGardenPlots.length;
  }

  Point<int> _getStartingPoint() {
    for (int i = 0; i < map.length; i++) {
      if (map[i].contains('S')) {
        return Point<int>(i, map[i].indexOf('S'));
      }
    }

    throw Exception('No starting point found');
  }

  List<Point<int>> _getPossibleNextSteps(Point<int> position) {
    List<Point<int>> nextSteps = [];

    if (position.x > 0 && map[position.x - 1][position.y] != '#') {
      nextSteps.add(Point<int>(position.x - 1, position.y));
    }

    if (position.x < map.length - 1 && map[position.x + 1][position.y] != '#') {
      nextSteps.add(Point<int>(position.x + 1, position.y));
    }

    if (position.y > 0 && map[position.x][position.y - 1] != '#') {
      nextSteps.add(Point<int>(position.x, position.y - 1));
    }

    if (position.y < map[position.x].length - 1 &&
        map[position.x][position.y + 1] != '#') {
      nextSteps.add(Point<int>(position.x, position.y + 1));
    }

    return nextSteps;
  }

  void _show(Set<Point<int>> visitedGardenPlots) {
    for (int i = 0; i < map.length; i++) {
      for (int j = 0; j < map[i].length; j++) {
        if (visitedGardenPlots.contains(Point(i, j))) {
          stdout.write('O');
        } else {
          stdout.write(map[i][j]);
        }
      }
      print('');
    }
  }
}
