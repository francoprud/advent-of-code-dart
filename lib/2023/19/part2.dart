import 'dart:io';
import 'dart:math';

void main() {
  final System system = System('lib/2023/19/input.txt');

  print(system.evaluate());
}

class System {
  Map<String, Workflow> workflows = {};

  System(String filename) {
    _parseFile(File(filename));
  }

  int evaluate() {
    Map<String, ({int low, int high})> ranges = {
      'x': (low: 1, high: 4000),
      'm': (low: 1, high: 4000),
      'a': (low: 1, high: 4000),
      's': (low: 1, high: 4000),
    };

    return _count(ranges, 'in');
  }

  int _count(Map<String, ({int low, int high})> ranges, String workflowKey) {
    if (workflowKey == 'R') return 0;
    if (workflowKey == 'A') {
      int product = 1;

      for (({int low, int high}) range in ranges.values) {
        product *= range.high - range.low + 1;
      }

      return product;
    }

    Workflow workflow = workflows[workflowKey]!;
    int totalCombinations = 0;

    for (Condition condition in workflow.conditions) {
      if (condition.operator == null) {
        totalCombinations += _count(ranges, condition.workflow);
      } else {
        int low = ranges[condition.variable!]!.low;
        int high = ranges[condition.variable!]!.high;
        ({int low, int high})? trueSide, falseSide;

        if (condition.operator == '<') {
          trueSide = (low: low, high: [condition.value! - 1, high].reduce(min));
          falseSide = (low: [condition.value!, low].reduce(max), high: high);
        } else {
          trueSide = (low: [condition.value! + 1, low].reduce(max), high: high);
          falseSide = (low: low, high: [condition.value!, high].reduce(min));
        }

        if (trueSide.low <= trueSide.high) {
          Map<String, ({int low, int high})> copyRanges = Map.from(ranges);
          copyRanges[condition.variable!] = trueSide;
          totalCombinations += _count(copyRanges, condition.workflow);
        }

        if (falseSide.low <= falseSide.high) {
          ranges[condition.variable!] = falseSide;
        } else {
          break;
        }
      }
    }
    return totalCombinations;
  }

  void _parseFile(File file) {
    List<String> lines = file.readAsLinesSync();
    bool workflowSection = true;

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].isEmpty) {
        workflowSection = false;
      } else if (workflowSection) {
        List<String> workflow = lines[i].split('{');
        workflows[workflow[0]] =
            Workflow(workflow[0], workflow[1].substring(0, workflow[1].length - 1));
      }
    }
  }
}

class Workflow {
  late String key;
  late List<Condition> conditions = [];

  Workflow(String key, String line) {
    this.key = key;
    line.split(',').forEach((element) => conditions.add(Condition(element)));
  }
}

class Condition {
  String? variable = null;
  String? operator = null;
  int? value = null;
  late String workflow;

  Condition(String line) {
    if (line.contains(':')) {
      RegExp exp = RegExp(r'([xmas]{1})([<>]{1})(\d+):([a-zAR]+)');

      this.variable = exp.firstMatch(line)!.group(1)!;
      this.operator = exp.firstMatch(line)!.group(2)!;
      this.value = int.parse(exp.firstMatch(line)!.group(3)!);
      this.workflow = exp.firstMatch(line)!.group(4)!;
    } else {
      this.workflow = line;
    }
  }
}
