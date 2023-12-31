import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';

Set<({Point<int> position, Point<int> direction, int consecutiveBlocks})> _seen = {};

void main() {
  int? heat;
  HeapPriorityQueue<Crucible> cruciblesQueue = HeapPriorityQueue();

  List<List<int>> layout = getLayout('lib/2023/17/input.txt');
  cruciblesQueue.add(Crucible(Point(0, 0), Point(0, 1), 0, 0));
  cruciblesQueue.add(Crucible(Point(0, 0), Point(1, 0), 0, 0));

  while (cruciblesQueue.isNotEmpty) {
    Crucible currentCrucible = cruciblesQueue.removeFirst();

    if (_seen.contains((
      position: currentCrucible.position,
      direction: currentCrucible.direction,
      consecutiveBlocks: currentCrucible.consecutiveBlocks
    ))) {
      continue;
    }

    _seen.add((
      position: currentCrucible.position,
      direction: currentCrucible.direction,
      consecutiveBlocks: currentCrucible.consecutiveBlocks
    ));

    // first encounter should be the minimum
    if (isEndingPosition(layout, currentCrucible.position)) {
      print(currentCrucible.heatLoss);
      return;
    }

    // try to go straight
    Point<int> nextPosition = currentCrucible.position + currentCrucible.direction;
    if (belongsToLayout(layout, nextPosition) &&
        currentCrucible.consecutiveBlocks < 3) {
      heat = layout[nextPosition.x][nextPosition.y] + currentCrucible.heatLoss;

      cruciblesQueue.add(Crucible(nextPosition, currentCrucible.direction,
          currentCrucible.consecutiveBlocks + 1, heat));
    }

    // try to go left
    Point<int> newDirection = Point<int>(currentCrucible.direction.x == 0 ? -1 : 0,
        currentCrucible.direction.y == 0 ? -1 : 0);
    nextPosition = currentCrucible.position + newDirection;
    if (belongsToLayout(layout, nextPosition)) {
      heat = layout[nextPosition.x][nextPosition.y] + currentCrucible.heatLoss;

      cruciblesQueue.add(Crucible(nextPosition, newDirection, 1, heat));
    }

    // try to go right
    newDirection = Point<int>(currentCrucible.direction.x == 0 ? 1 : 0,
        currentCrucible.direction.y == 0 ? 1 : 0);
    nextPosition = currentCrucible.position + newDirection;
    if (belongsToLayout(layout, nextPosition)) {
      heat = layout[nextPosition.x][nextPosition.y] + currentCrucible.heatLoss;

      cruciblesQueue.add(Crucible(nextPosition, newDirection, 1, heat));
    }
  }
}

List<List<int>> getLayout(String filename) => File(filename)
    .readAsLinesSync()
    .map((line) => line.split('').map(int.parse).toList())
    .toList();

bool isEndingPosition(List<List<int>> layout, Point<int> position) =>
    position.x == layout.length - 1 && position.y == layout[0].length - 1;

bool belongsToLayout(List<List<int>> layout, Point<int> position) =>
    position.x >= 0 &&
    position.y >= 0 &&
    position.x < layout.length &&
    position.y < layout[0].length;

class Crucible implements Comparable<Crucible> {
  Point<int> position;
  Point<int> direction;
  int consecutiveBlocks = 0;
  int heatLoss = 0;

  Crucible(this.position, this.direction, this.consecutiveBlocks, this.heatLoss);

  @override
  int compareTo(Crucible other) {
    return heatLoss.compareTo(other.heatLoss);
  }
}
