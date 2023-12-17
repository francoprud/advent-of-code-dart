import 'dart:io';
import 'dart:math';

void main() {
  Universe universe = Universe.build('lib/2023/11/input.txt');
  universe.show();
  universe.expand();
  universe.show();
  // print(universe.getTotalDistances());
}

class Universe {
  List<List<String>> map = [];
  List<Point> galaxies = [];
  Set<int> _rowsWithGalaxies = {}, _columnsWithGalaxies = {};

  Universe(List<List<String>> map) {
    this.map = map;
    _getGalaxies();
  }

  factory Universe.build(String filename) {
    List<List<String>> map =
        File(filename).readAsLinesSync().map((line) => line.split('')).toList();

    return Universe(map);
  }

  void show() {
    print('--------------------------');
    for (int i = 0; i < map.length; i++) {
      for (int j = 0; j < map[i].length; j++) {
        stdout.write(map[i][j]);
      }
      print('');
    }
    print('Galaxies (${galaxies.length}) -> $galaxies');
    print(
        'Rows With Galaxies -> (${_rowsWithGalaxies.length}) -> $_rowsWithGalaxies');
    print(
        'Columns With Galaxies -> (${_columnsWithGalaxies.length}) -> $_columnsWithGalaxies');
  }

  void expand() {
    // expand rows
    int timesExpanded = 0;
    _getNotIncludedNumbers(map.length, _rowsWithGalaxies).forEach((element) {
      map.insert(element + timesExpanded++,
          new List<String>.generate(map[0].length, (i) => '.').toList());
    });
    // expand columns
    timesExpanded = 0;
    _getNotIncludedNumbers(map[0].length, _columnsWithGalaxies).forEach((element) {
      for (int i = 0; i < map.length; i++) {
        map[i].insert(element + timesExpanded, '.');
      }
      timesExpanded++;
    });
    // update galaxies positions
    _getGalaxies();
  }

  int getTotalDistances() {
    int totalDistance = 0;

    for (int i = 0; i < galaxies.length; i++) {
      for (int j = i + 1; j < galaxies.length; j++) {
        totalDistance += _getDistanceBetweenGalaxies(galaxies[i], galaxies[j]);
      }
    }

    return totalDistance;
  }

  int _getDistanceBetweenGalaxies(Point g1, Point g2) {
    return ((g1.x - g2.x) as int).abs() + ((g1.y - g2.y) as int).abs();
  }

  void _getGalaxies() {
    galaxies = [];
    _rowsWithGalaxies = {};
    _columnsWithGalaxies = {};

    for (int i = 0; i < map.length; i++) {
      for (int j = 0; j < map[i].length; j++) {
        if (map[i][j] == '#') {
          galaxies.add(Point(i, j));
          _rowsWithGalaxies.add(i);
          _columnsWithGalaxies.add(j);
        }
      }
    }
  }

  List<int> _getNotIncludedNumbers(int mapSize, Set<int> numbers) {
    Set<int> fullSet = new List<int>.generate(mapSize - 1, (i) => i + 1).toSet();
    List<int> fullList = fullSet.difference(numbers).toList();
    fullList.sort();

    return fullList;
  }
}
