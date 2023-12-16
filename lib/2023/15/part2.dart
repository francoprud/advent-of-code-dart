import 'dart:io';

Map<int, List<({String label, int focal})>> _boxes = {};

void main() {
  int totalFocusingPower = 0;

  getSteps().forEach((step) => handleStep(step));

  _boxes.forEach((boxNumber, values) {
    for (int i = 0; i < values.length; i++) {
      totalFocusingPower += (boxNumber + 1) * (i + 1) * values[i].focal;
    }
  });

  print(totalFocusingPower);
}

List<String> getSteps() {
  return File('lib/2023/15/input.txt').readAsLinesSync()[0].split(',');
}

({String label, String operation, int? focal}) parseStep(String step) {
  String label = '', operation = '';
  int? focal;

  if (step.contains('-')) {
    label = step.split('-')[0];
    operation = '-';
  } else {
    label = step.split('=')[0];
    focal = int.parse(step.split('=')[1]);
    operation = '=';
  }

  return (label: label, operation: operation, focal: focal);
}

int getHashValue(String s) {
  return s.codeUnits.fold(0, (previousValue, asciiCode) {
    previousValue = (previousValue + asciiCode) * 17;
    previousValue = previousValue.remainder(256);

    return previousValue;
  });
}

void handleStep(String step) {
  ({String label, String operation, int? focal}) parsedStep = parseStep(step);

  if (parsedStep.operation == '-') {
    removeFromBoxes(parsedStep.label);
  } else {
    addToBoxes(parsedStep.label, parsedStep.focal!);
  }
}

void removeFromBoxes(String label) {
  int hashValue = getHashValue(label);

  _boxes.update(hashValue, (value) {
    final index = value.indexWhere((e) => e.label == label);
    if (index != -1) value.removeAt(index);

    return value;
  }, ifAbsent: () => []);
}

void addToBoxes(String label, int focal) {
  int hashValue = getHashValue(label);
  ({String label, int focal}) newValue = (label: label, focal: focal);

  _boxes.update(hashValue, (value) {
    final index = value.indexWhere((e) => e.label == label);
    if (index != -1) {
      value[index] = newValue;
    } else {
      value.add(newValue);
    }

    return value;
  }, ifAbsent: () => [newValue]);
}
