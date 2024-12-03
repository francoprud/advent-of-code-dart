import 'dart:async';
import 'dart:convert';
import 'dart:io';

bool considerInstruction = true;

void main() async {
  print(await addInstructions('lib/2024/03/input.txt'));
}

Future<int> addInstructions(String path) async {
  return File(path)
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .transform(const InstructionsResultsParser())
      .reduce((sum, value) => sum + value);
}

class InstructionsResultsParser implements StreamTransformer<String, int> {
  const InstructionsResultsParser();

  @override
  Stream<int> bind(Stream<String> stream) {
    return stream.map(_parseInstructionsLine);
  }

  int _parseInstructionsLine(String line) {
    RegExp exp = RegExp(r"don't\(\)|do\(\)|mul\((\d{1,3}),(\d{1,3})\)");
    List<int> numbers = [];

    for (final match in exp.allMatches(line)) {
      if (match.group(0) == "do()") {
        considerInstruction = true;
      } else if (match.group(0) == "don't()") {
        considerInstruction = false;
      } else {
        if (considerInstruction) {
          numbers.add(int.parse(match.group(1)!) * int.parse(match.group(2)!));
        }
      }
    }

    return numbers.reduce((sum, value) => sum + value);
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() => StreamTransformer.castFrom(this);
}
