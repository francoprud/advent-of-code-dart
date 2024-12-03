import 'dart:async';

class LineToIntListParser implements StreamTransformer<String, List<int>> {
  const LineToIntListParser();

  @override
  Stream<List<int>> bind(Stream<String> stream) {
    return stream.map((line) => line.split(' ').map(int.parse).toList());
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() => StreamTransformer.castFrom(this);
}
