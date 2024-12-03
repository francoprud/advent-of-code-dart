import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

typedef RangePair = ({Point<int> first, Point<int> second});

void main() async {
  print(await countOverlappingRanges('lib/2022/04/input.txt'));
}

Future<int> countOverlappingRanges(String path) async {
  return File(path)
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .transform(const RangeParser())
      .where(hasPartialOverlap)
      .length;
}

bool hasPartialOverlap(RangePair ranges) {
  final first = ranges.first;
  final second = ranges.second;

  return first.x <= second.y && second.x <= first.y;
}

class RangeParser implements StreamTransformer<String, RangePair> {
  const RangeParser();

  @override
  Stream<RangePair> bind(Stream<String> stream) {
    return stream.map(_parseRangePair);
  }

  RangePair _parseRangePair(String line) {
    final ranges = line.split(',').map(_parseRange).toList();
    return (first: ranges[0], second: ranges[1]);
  }

  Point<int> _parseRange(String range) {
    final bounds = range.split('-');
    return Point<int>(
      int.parse(bounds[0]),
      int.parse(bounds[1]),
    );
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() => StreamTransformer.castFrom(this);
}
