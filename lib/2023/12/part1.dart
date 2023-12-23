import 'dart:convert';
import 'dart:io';

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
  List<String> springs = s.split(' ')[0].split('');
  List<int> numbers = s.split(' ')[1].split(',').map(int.parse).toList();

  return _getArrangements(springs, numbers);
}

int _getArrangements(List<String> springs, List<int> numbers) {
  if (springs.isEmpty) return numbers.isEmpty ? 1 : 0;
  if (numbers.isEmpty) return springs.contains('#') ? 0 : 1;

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

  return arrangements;
}
