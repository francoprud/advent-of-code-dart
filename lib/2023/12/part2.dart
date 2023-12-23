import 'dart:convert';
import 'dart:io';

Map<String, int> _cache = {};

void main() {
  int totalArrangements = 0;

  File('lib/2023/12/input.txt')
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .listen(
        (event) => totalArrangements += getArrangements(event),
        onDone: () => print(totalArrangements),
      );
}

int getArrangements(String s) {
  String springs = s.split(' ')[0];
  String numbers = s.split(' ')[1];

  return _getArrangements((springs + ('?$springs' * 4)).split(''),
      (numbers + (',$numbers' * 4)).split(',').map(int.parse).toList());
}

int _getArrangements(List<String> springs, List<int> numbers) {
  if (springs.isEmpty) return numbers.isEmpty ? 1 : 0;
  if (numbers.isEmpty) return springs.contains('#') ? 0 : 1;

  if (_cache.containsKey('$springs-$numbers')) {
    return _cache['$springs-$numbers']!;
  }

  int arrangements = 0;

  if ('.?'.contains(springs[0])) {
    arrangements += _getArrangements(springs.sublist(1), numbers);
  }

  if ('#?'.contains(springs[0])) {
    if (numbers[0] <= springs.length &&
        !springs.sublist(0, numbers[0]).contains('.') &&
        (numbers[0] == springs.length || springs[numbers[0]] != '#')) {
      arrangements += _getArrangements(
          numbers[0] + 1 <= springs.length ? springs.sublist(numbers[0] + 1) : [],
          numbers.sublist(1));
    }
  }

  _cache['$springs-$numbers'] = arrangements;

  return arrangements;
}
