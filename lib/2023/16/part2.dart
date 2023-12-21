import 'dart:collection';
import 'dart:io';
import 'dart:math';

void main() {
  List<List<String>> layout = getLayout('lib/2023/16/input.txt');
  int maximumEnergy = 0;

  for (int i = 0; i < layout.length; i++) {
    maximumEnergy = max(maximumEnergy,
        getLayoutEnergy(layout, Beam(Point(i, -1), Point(0, 1)))); // for left side
    maximumEnergy = max(
        maximumEnergy,
        getLayoutEnergy(layout,
            Beam(Point(i, layout[0].length), Point(0, -1)))); // for right side
  }

  for (int i = 0; i < layout[0].length; i++) {
    maximumEnergy = max(maximumEnergy,
        getLayoutEnergy(layout, Beam(Point(-1, i), Point(1, 0)))); // for top side
    maximumEnergy = max(
        maximumEnergy,
        getLayoutEnergy(
            layout, Beam(Point(layout.length, i), Point(-1, 0)))); // for bottom side
  }

  print(maximumEnergy);
}

List<List<String>> getLayout(String filename) =>
    File(filename).readAsLinesSync().map((line) => line.split('')).toList();

int getLayoutEnergy(List<List<String>> layout, Beam startingBeam) {
  Queue<Beam> beamsQueue = Queue.of([startingBeam]);
  Set<Beam> seen = {};

  while (beamsQueue.isNotEmpty) {
    Beam previousBeam = beamsQueue.removeFirst();
    Beam currentBeam = Beam(previousBeam.position + previousBeam.direction,
        previousBeam.direction); // move the beam

    if (seen.contains(currentBeam) || isOffRange(currentBeam.position, layout)) {
      continue;
    }

    String c = layout[currentBeam.position.x][currentBeam.position.y];

    if (c == '.' ||
        (c == '-' && currentBeam.direction.y != 0) ||
        (c == '|' && currentBeam.direction.x != 0)) {
      beamsQueue.add(currentBeam);
    } else if (c == '/') {
      beamsQueue.add(Beam(currentBeam.position,
          Point(-currentBeam.direction.y, -currentBeam.direction.x)));
    } else if (c == '\\') {
      beamsQueue.add(Beam(currentBeam.position,
          Point(currentBeam.direction.y, currentBeam.direction.x)));
    } else if (c == '|') {
      beamsQueue.add(Beam(currentBeam.position, Point(1, 0)));
      beamsQueue.add(Beam(currentBeam.position, Point(-1, 0)));
    } else if (c == '-') {
      beamsQueue.add(Beam(currentBeam.position, Point(0, 1)));
      beamsQueue.add(Beam(currentBeam.position, Point(0, -1)));
    }

    seen.add(currentBeam);
  }

  return Set.from(seen.map((beam) => beam.position)).length;
}

bool isOffRange(Point p, List<List<String>> layout) =>
    p.x < 0 || p.y < 0 || p.x >= layout.length || p.y >= layout[0].length;

class Beam {
  Point<int> position;
  Point<int> direction; // the direction the beam is going

  Beam(this.position, this.direction);

  bool operator ==(Object other) =>
      other is Beam && position == other.position && direction == other.direction;

  int get hashCode => Object.hash(position, direction);

  String toString() => 'Beam: $position | $direction';
}
