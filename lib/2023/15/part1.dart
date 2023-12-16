import 'dart:io';

void main() {
  print(getSteps()
      .fold<int>(0, (previousValue, step) => previousValue + getHashValue(step)));
}

List<String> getSteps() {
  return File('lib/2023/15/input.txt').readAsLinesSync()[0].split(',');
}

int getHashValue(String s) {
  return s.codeUnits.fold(0, (previousValue, asciiCode) {
    previousValue = (previousValue + asciiCode) * 17;
    previousValue = previousValue.remainder(256);

    return previousValue;
  });
}
