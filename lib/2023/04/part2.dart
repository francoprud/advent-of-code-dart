import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main() {
  final File file = File('lib/2023/04/input.txt');
  Map<int, int> amountPerScratchcard = {};
  int totalScratchcards = 0;

  file.openRead().transform(utf8.decoder).transform(LineSplitter()).listen(
    (event) {
      final Scratchcard scratchcard = Scratchcard.parse(event);

      amountPerScratchcard.update(scratchcard.id, (value) => value + 1, ifAbsent: () => 1);

      for (int times = 0; times < amountPerScratchcard[scratchcard.id]!; times++) {
        for (int i = scratchcard.id + 1; i < scratchcard.id + 1 + scratchcard.matchingNumbers(); i++) {
          amountPerScratchcard.update(i, (value) => value + 1, ifAbsent: () => 1);
        }
      }

      totalScratchcards += amountPerScratchcard[scratchcard.id]!;
    },
    onDone: () => print(totalScratchcards),
  );
}

class Scratchcard {
  final int id;
  final Set<int> winningNumbers, playedNumbers;

  Scratchcard(
      {required int this.id,
      required Set<int> this.winningNumbers,
      required Set<int> this.playedNumbers});

  factory Scratchcard.parse(String s) {
    return Scratchcard(
        id: getIdFromCard(s),
        winningNumbers: getWinningNumbers(s).toSet(),
        playedNumbers: getPlayedNumbers(s).toSet());
  }

  int points() {
    int numbers = matchingNumbers();

    return numbers == 0 ? 0 : (pow(2, numbers - 1)) as int;
  }

  int matchingNumbers() {
    return winningNumbers.intersection(playedNumbers).length;
  }

  String toString() {
    return '$id: $winningNumbers | $playedNumbers => Matching: ${matchingNumbers()} - Points: ${points()}';
  }

  static int getIdFromCard(String s) {
    RegExp exp = RegExp(r'(\d+):');

    return int.parse(exp.firstMatch(s)!.group(1)!);
  }

  static List<int> extractNumbers(String cardData) {
    final numbersString = cardData.trim();
    final numbersList = numbersString.replaceAll('  ', ' ').split(' ');

    return numbersList.map((number) => int.parse(number)).toList();
  }

  static List<int> getWinningNumbers(String cardData) {
    return extractNumbers(cardData.substring(cardData.indexOf(':') + 1).split('|')[0]);
  }

  static List<int> getPlayedNumbers(String cardData) {
    return extractNumbers(cardData.split('|')[1]);
  }
}
