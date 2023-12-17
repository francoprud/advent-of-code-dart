import 'dart:io';
import 'dart:math';

void main() {
  Universe universe = Universe.build('lib/2023/11/input.txt');
  universe.expand();
  print(universe.getTotalDistances());
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
    List<int> rowsWithoutGalaxies =
        _getNotIncludedNumbers(map.length, _rowsWithGalaxies);
    List<int> columnsWithoutGalaxies =
        _getNotIncludedNumbers(map[0].length, _columnsWithGalaxies);

    for (int i = 0; i < galaxies.length; i++) {
      Point galaxy = galaxies[i];
      galaxies[i] = Point(
          _getCoordinateAfterExpansion(rowsWithoutGalaxies, galaxy.x),
          _getCoordinateAfterExpansion(columnsWithoutGalaxies, galaxy.y));
    }
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

  int _getCoordinateAfterExpansion(List<int> list, num position) {
    int count = list.where((element) => element < position).length;

    return count * (1000000 - 1) + position as int;
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
