import 'dart:math';

import 'package:jlpt_jonggack/model/grammar.dart';

class GrammarQustionWord {
  final String word;
  final String mean;
  final String yomikata;
  final Grammar originGrammar;
  GrammarQustionWord({
    required this.word,
    required this.mean,
    required this.yomikata,
    required this.originGrammar,
  });
}

class GrammarQuestion {
  final int answer;
  final GrammarQustionWord question;
  final List<GrammarQustionWord> options;

  GrammarQuestion({
    required this.answer,
    required this.question,
    required this.options,
  });

  static generateQustion(List<GrammarQustionWord> grammars) {
    List<Map<int, List<GrammarQustionWord>>> map = List.empty(growable: true);
    for (var i = 0; i < grammars.length; i++) {
      Map<int, List<GrammarQustionWord>> voca = generateAnswer(grammars, i);
      map.add(voca);
    }
    map.shuffle();

    return map;
  }

  static Map<int, List<GrammarQustionWord>> generateAnswer(
    List<GrammarQustionWord> vocas,
    int currentIndex,
  ) {
    Random random = Random();

    List<int> answerIndexs = List.empty(growable: true);

    for (int i = 0; i < 4; i++) {
      int randomNumber = random.nextInt(vocas.length);
      while (answerIndexs.contains(randomNumber)) {
        randomNumber = random.nextInt(vocas.length);
      }
      answerIndexs.add(randomNumber);
    }

    int correctIndex = answerIndexs.indexOf(currentIndex);

    if (correctIndex == -1) {
      int randomNumber = random.nextInt(4);
      answerIndexs[randomNumber] = currentIndex;
      correctIndex = randomNumber;
    }

    List<GrammarQustionWord> answerVoca = List.empty(growable: true);

    for (int j = 0; j < answerIndexs.length; j++) {
      final answerIndex = answerIndexs[j];
      final grammar = vocas[answerIndex];

      answerVoca.add(grammar);
    }

    return {correctIndex: answerVoca};
  }
}
