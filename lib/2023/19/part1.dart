import 'dart:io';

void main() {
  final System system = System('lib/2023/19/input.txt');

  print(system.evaluate());
}

class System {
  Map<String, Workflow> workflows = {};
  List<Part> parts = [];

  System(String filename) {
    _parseFile(File(filename));
  }

  int evaluate() {
    int accumulator = 0;

    for (Part part in parts) {
      if (_isAccepted(part)) accumulator += part.ratingSum();
    }

    return accumulator;
  }

  bool _isAccepted(Part part) {
    String workflowKey = 'in';

    while (!'AR'.contains(workflowKey)) {
      Workflow workflow = workflows[workflowKey]!;

      for (Condition condition in workflow.conditions) {
        String? partialWorkflowKey = condition.evaluate(part);

        if (partialWorkflowKey != null) {
          workflowKey = partialWorkflowKey;
          break;
        }
      }
    }

    return workflowKey == 'A';
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
      } else {
        parts.add(Part(lines[i]));
      }
    }
  }
}

class Part {
  late int x, m, a, s;

  Part(String line) {
    RegExp exp = RegExp(r'[^\d]*(\d+),[^\d]*(\d+),[^\d]*(\d+),[^\d]*(\d+)');

    this.x = int.parse(exp.firstMatch(line)!.group(1)!);
    this.m = int.parse(exp.firstMatch(line)!.group(2)!);
    this.a = int.parse(exp.firstMatch(line)!.group(3)!);
    this.s = int.parse(exp.firstMatch(line)!.group(4)!);
  }

  int ratingSum() => x + m + a + s;

  Map<String, int> toMap() {
    return {
      'x': x,
      'm': m,
      'a': a,
      's': s,
    };
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

  String? evaluate(Part part) {
    if (operator == null) return workflow;

    switch (operator) {
      case '>':
        return part.toMap()[variable!]! > value! ? workflow : null;
      case '<':
        return part.toMap()[variable!]! < value! ? workflow : null;
      default:
        throw Exception('Invalid operator');
    }
  }
}
