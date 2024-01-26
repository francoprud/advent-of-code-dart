import 'dart:collection';
import 'dart:io';
import 'dart:math';

void main() {
  List<List<String>> map = File('lib/2023/23/input.txt')
      .readAsLinesSync()
      .map((line) => line.split(''))
      .toList();
  int longestPath = 0;
  Queue<Step> queue = Queue();
  queue.add(Step(Point(0, 1), 0, {Point(0, 1)}));

  while (queue.isNotEmpty) {
    var current = queue.removeFirst();

    if (current.isFinalStep(map)) {
      print(current.pathLength);
      longestPath = [current.pathLength, longestPath].reduce(max);
      continue;
    }

    for (Step nextStep in current.possibleNextSteps(map)) {
      queue.add(nextStep);
    }
  }

  print(longestPath);
}

class Step {
  Point<int> position;
  int pathLength;
  Set<Point<int>> visitedPoints;

  Step(position, pathLength, visitedPoints)
      : position = position,
        pathLength = pathLength,
        visitedPoints = visitedPoints;

  List<Step> possibleNextSteps(map) {
    List<Step> nextSteps = [];
    Point<int> nextPosition;

    if (map[position.x][position.y] == '>') {
      nextPosition = Point<int>(position.x, position.y + 1);

      if (nextPosition.y < map[position.x].length &&
          !visitedPoints.contains(nextPosition)) {
        nextSteps.add(
            Step(nextPosition, pathLength + 1, copyVisitedPoints(nextPosition)));
      }
      return nextSteps;
    } else if (map[position.x][position.y] == 'v') {
      nextPosition = Point<int>(position.x + 1, position.y);

      if (nextPosition.x < map.length && !visitedPoints.contains(nextPosition)) {
        nextSteps.add(
            Step(nextPosition, pathLength + 1, copyVisitedPoints(nextPosition)));
      }
      return nextSteps;
    }

    if (position.x > 0 &&
        map[position.x - 1][position.y] != '#' &&
        !visitedPoints.contains(Point(position.x - 1, position.y))) {
      nextPosition = Point<int>(position.x - 1, position.y);
      nextSteps
          .add(Step(nextPosition, pathLength + 1, copyVisitedPoints(nextPosition)));
    }

    if (position.x < map.length - 1 &&
        map[position.x + 1][position.y] != '#' &&
        !visitedPoints.contains(Point(position.x + 1, position.y))) {
      nextPosition = Point<int>(position.x + 1, position.y);
      nextSteps
          .add(Step(nextPosition, pathLength + 1, copyVisitedPoints(nextPosition)));
    }

    if (position.y > 0 &&
        map[position.x][position.y - 1] != '#' &&
        !visitedPoints.contains(Point(position.x, position.y - 1))) {
      nextPosition = Point<int>(position.x, position.y - 1);
      nextSteps
          .add(Step(nextPosition, pathLength + 1, copyVisitedPoints(nextPosition)));
    }

    if (position.y < map[position.x].length - 1 &&
        map[position.x][position.y + 1] != '#' &&
        !visitedPoints.contains(Point(position.x, position.y + 1))) {
      nextPosition = Point<int>(position.x, position.y + 1);
      nextSteps
          .add(Step(nextPosition, pathLength + 1, copyVisitedPoints(nextPosition)));
    }

    return nextSteps;
  }

  Set<Point<int>> copyVisitedPoints(Point<int> position) {
    Set<Point<int>> copySet = Set.from(visitedPoints);
    copySet.add(position);
    return copySet;
  }

  bool isFinalStep(map) {
    return position.x == map.length - 1 && position.y == map[position.x].length - 2;
  }
}
