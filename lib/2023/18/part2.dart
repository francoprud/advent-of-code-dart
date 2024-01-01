import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main() {
  DigPlan digPlan = DigPlan();

  File('lib/2023/18/input.txt')
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .listen(
        (event) => digPlan.parseAction(event),
        onDone: () => print(digPlan.calculateCubicMeters()),
      );
}

class DigPlan {
  Point<int> _currentCoordinate = Point(0, 0);
  List<Point<int>> _coordinates = [Point(0, 0)];
  Map<int, String> _directions = {
    0: 'R',
    1: 'D',
    2: 'L',
    3: 'U',
  };

  void parseAction(String s) {
    String color = s.split(' ')[2];
    int steps = int.parse(color.substring(2, 7), radix: 16);
    String direction = _directions[int.parse(color.substring(7, 8))]!;

    for (int i = 0; i < steps; i++) {
      if (direction == 'R') {
        _currentCoordinate = Point(_currentCoordinate.x, _currentCoordinate.y + 1);
      } else if (direction == 'L') {
        _currentCoordinate = Point(_currentCoordinate.x, _currentCoordinate.y - 1);
      } else if (direction == 'D') {
        _currentCoordinate = Point(_currentCoordinate.x + 1, _currentCoordinate.y);
      } else if (direction == 'U') {
        _currentCoordinate = Point(_currentCoordinate.x - 1, _currentCoordinate.y);
      }

      Point<int> newCoordinate = Point(_currentCoordinate.x, _currentCoordinate.y);
      _coordinates.add(newCoordinate);
    }
  }

  // combination of Gauss's area formula (Shoelace) and Pick's theorem
  int calculateCubicMeters() {
    // Gauss's area formula (Shoelace)
    int area = 0;
    for (int i = 1; i < _coordinates.length - 1; i++) {
      area += _coordinates[i].x * (_coordinates[i + 1].y - _coordinates[i - 1].y);
    }
    area = area.abs() ~/ 2;

    // Pick's theorem
    int boundaryPoints = _coordinates.length;
    int interiorPoints = area - boundaryPoints ~/ 2 + 1;

    // removing the double (0, 0) point
    return interiorPoints + boundaryPoints - 1;
  }
}
