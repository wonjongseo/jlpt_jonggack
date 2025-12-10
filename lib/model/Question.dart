import 'dart:math';

import 'package:hive/hive.dart';
import 'package:jlpt_jonggack/features/setting/screen/setting_screen.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/hive_type.dart';
import 'package:jlpt_jonggack/model/word.dart';

part 'Question.g.dart';

@HiveType(typeId: QuestionTypeId)
class Question {
  static String boxKey = 'question_key';
  @HiveField(0)
  int answer;
  @HiveField(1)
  final Word question;
  @HiveField(2)
  final List<Word> options;

  Question({
    required this.question,
    required this.answer,
    required this.options,
  });

  @override
  String toString() {
    return 'Question{answer: $answer,question: $question, options: $options}';
  }

  static Map<int, List<Word>> generateAnswer(
    List<Word> vocas,
    int currentIndex,
  ) {
    Random random = Random();

    List<int> answerIndex = List.empty(growable: true);

    for (int i = 0; i < 4; i++) {
      int randomNumber = random.nextInt(vocas.length);
      while (answerIndex.contains(randomNumber)) {
        randomNumber = random.nextInt(vocas.length);
      }
      answerIndex.add(randomNumber);
    }

    int correctIndex = answerIndex.indexOf(currentIndex);
    if (correctIndex == -1) {
      int randomNumber = random.nextInt(4);
      answerIndex[randomNumber] = currentIndex;
      correctIndex = randomNumber;
    }

    List<Word> answerVoca = List.empty(growable: true);

    for (int j = 0; j < answerIndex.length; j++) {
      String tempMean = vocas[answerIndex[j]].mean;
      bool isMeanOverThree = tempMean.contains('\n3.');
      bool isMeanOverTwo = tempMean.contains('\n2.');

      if (isKo) {
        if (isMeanOverThree) {
          tempMean = tempMean.replaceAll('3.', '');
          tempMean = tempMean.replaceAll('2.', '');
          tempMean = tempMean.replaceAll('1.', '');
          List<String> speartea = tempMean.split('\n');
          int randomIndex = random.nextInt(speartea.length);

          tempMean = speartea[randomIndex];
        }
        if (isMeanOverTwo) {
          tempMean = tempMean.replaceAll('2.', '');
          tempMean = tempMean.replaceAll('1.', '');
          List<String> speartea = tempMean.split('\n');
          int randomIndex = random.nextInt(speartea.length);

          tempMean = speartea[randomIndex];
        }
      } else {
        // 한자는 , 로 구분되어있고
        var splited = splitMeanings(tempMean);

        if (splited.length > 1) {
          final splitedMeanIdx = random.nextInt(splited.length);
          tempMean = splited[splitedMeanIdx];
        }
      }

      String word = vocas[answerIndex[j]].word;
      if (word.isEmpty) {
        word = vocas[answerIndex[j]].yomikata;
      }
      Word newWord = Word(
        word: word,
        mean: tempMean,
        yomikata: vocas[answerIndex[j]].yomikata,
        headTitle: vocas[answerIndex[j]].headTitle,
      );

      answerVoca.add(newWord);
    }

    return {correctIndex: answerVoca};
  }

  static List<Map<int, List<Word>>> generateQustion(List<Word> vocas) {
    List<Map<int, List<Word>>> map = List.empty(growable: true);
    for (int i = 0; i < vocas.length; i++) {
      Map<int, List<Word>> voca = generateAnswer(vocas, i);
      map.add(voca);
    }

    map.shuffle();

    return map;
  }

  static List<String> splitMeanings(String s) {
    // 1) 전각/특수 구분자와 공백 정규화
    s = s
        .replaceAll('（', '(')
        .replaceAll('）', ')')
        .replaceAll('／', '/')
        .replaceAll('；', ';')
        .replaceAll('，', ',')
        .replaceAll('\u00A0', ' ') // non-breaking space
        .replaceAll('\u3000', ' '); // 전각 스페이스

    // 2) 괄호 블록 전부 제거 (여러 개 가능)
    //    "(...)" 전체를 지워서 콤마가 안 남도록
    while (true) {
      final next = s.replaceAll(RegExp(r'\s*\([^()]*\)'), '');
      if (next == s) break;
      s = next;
    }

    // 3) 원하는 구분자로 split (콤마까지 포함해도 이제 안전)
    final parts =
        s
            .split(RegExp(r'\s*[;,/]\s*')) // , ; /
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

    return parts;
  }
}
