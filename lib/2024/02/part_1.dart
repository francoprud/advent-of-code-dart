import 'dart:io';
import 'dart:convert';
import 'package:advent_of_code/helpers/stream_transformers/line_to_int_list_parser.dart';

void main() async {
  print(await countSafeReports('lib/2024/02/input.txt'));
}

Future<int> countSafeReports(String path) async {
  return File(path)
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .transform(const LineToIntListParser())
      .map(isReportSafe)
      .where((isSafe) => isSafe)
      .length;
}

bool isReportSafe(List<int> report) {
  const validDifferences = {1, 2, 3};
  final bool ascending = report[0] < report[1];

  for (int i = 1; i < report.length; i++) {
    if (ascending && report[i - 1] > report[i]) return false;
    if (!ascending && report[i - 1] < report[i]) return false;

    if (!validDifferences.contains((report[i - 1] - report[i]).abs()))
      return false;
  }

  return true;
}
