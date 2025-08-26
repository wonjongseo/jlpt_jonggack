import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/common/widget/custom_text_feild.dart';
import 'package:jlpt_jonggack/features/grammar_test/grammar_test_screen.dart';
import 'package:jlpt_jonggack/features/jlpt_home/screens/jlpt_home_screen.dart';
import 'package:jlpt_jonggack/features/jlpt_test/screens/jlpt_test_screen.dart';
import 'package:jlpt_jonggack/features/kangi_test/kangi_test_screen.dart';
import 'package:jlpt_jonggack/model/grammar.dart';
import 'package:jlpt_jonggack/model/grammar_step.dart';
import 'package:jlpt_jonggack/model/jlpt_step.dart';
import 'package:jlpt_jonggack/model/kangi.dart';
import 'package:jlpt_jonggack/model/kangi_step.dart';
import 'package:jlpt_jonggack/model/word.dart';

class RandomTestGenerator {
  static List<int> _createRandomIdx(int totalCount, int count) {
    Random random = Random();
    List<int> randomIdxs = [];
    while (randomIdxs.length < count) {
      int randomIdx = random.nextInt(totalCount);
      if (randomIdxs.contains(randomIdx)) {
        continue;
      }

      randomIdxs.add(randomIdx);
    }

    return randomIdxs;
  }

  static Future<List<Word>> _createJlptQuiz(
    int level,
    int count,
    List<Word> tempWords,
  ) async {
    List<Word> words = [];

    List<int> randomIdxs = _createRandomIdx(tempWords.length, count);
    for (var randomIdx in randomIdxs) {
      words.add(tempWords[randomIdx]);
    }

    return words;
  }

  static Future<List<Word>> _getAllJapaneseByLevel(int level) async {
    final box = Hive.box(JlptStep.boxKey);
    final keys = box.keys.where(
      (key) => (key as String).startsWith('$level-챕터'),
    );

    List<Word> tempWords = [];
    for (var key in keys) {
      Object jlptStep = box.get(key);
      if (jlptStep.runtimeType == JlptStep) {
        tempWords.addAll((jlptStep as JlptStep).words);
      }
    }
    return tempWords;
  }

  static Future<List<Kangi>> _createKangiQuiz(
    int level,
    int count,
    List<Kangi> tempKangis,
  ) async {
    List<Kangi> kangis = [];
    List<int> randomIdxs = _createRandomIdx(tempKangis.length, count);
    for (var randomIdx in randomIdxs) {
      kangis.add(tempKangis[randomIdx]);
    }
    return kangis;
  }

  static Future<List<Kangi>> _getAllKangisByLevel(int level) async {
    final box = Hive.box(KangiStep.boxKey);
    final keys = box.keys.where(
      (key) => (key as String).startsWith('$level-챕터'),
    );

    List<Kangi> tempKangis = [];
    for (var key in keys) {
      Object jlptStep = box.get(key);
      if (jlptStep.runtimeType == KangiStep) {
        tempKangis.addAll((jlptStep as KangiStep).kangis);
      }
    }
    return tempKangis;
  }

  static Future<List<Grammar>> _getAllGrammarByLevel(int level) async {
    final box = Hive.box(GrammarStep.boxKey);

    final keys = box.keys.where((key) => (key as String).startsWith('$level-'));

    List<Grammar> tempGrammars = [];
    for (var key in keys) {
      Object jlptStep = box.get(key);
      if (jlptStep.runtimeType == GrammarStep) {
        tempGrammars.addAll((jlptStep as GrammarStep).grammars);
      }
    }
    return tempGrammars;
  }

  static Future<List<Grammar>> _createGrammarQuiz(
    int level,
    int count,
    List<Grammar> tempGrammars,
  ) async {
    List<Grammar> grammars = [];

    List<int> randomIdxs = _createRandomIdx(tempGrammars.length, count);
    for (var randomIdx in randomIdxs) {
      grammars.add(tempGrammars[randomIdx]);
    }

    return grammars;
  }

  static Future test(int level, CategoryEnum category) async {
    List<Word> tempWords = [];
    List<Grammar> tempGrammars = [];
    List<Kangi> tempKangis = [];
    int? maxCount;

    switch (category) {
      case CategoryEnum.Japaneses:
        tempWords = await _getAllJapaneseByLevel(level);
        maxCount = tempWords.length;
      case CategoryEnum.Kangis:
        tempKangis = await _getAllKangisByLevel(level);
        maxCount = tempKangis.length;
      case CategoryEnum.Grammars:
        tempGrammars = await _getAllGrammarByLevel(level);
        maxCount = tempGrammars.length;
    }

    dynamic count = await Get.dialog(QuizCntForm(maxCount: maxCount));
    if (count == null || count.runtimeType != String) return;

    count = int.tryParse(count) ?? 15;

    switch (category) {
      case CategoryEnum.Japaneses:
        List<Word> words = await _createJlptQuiz(level, count, tempWords);
        Get.toNamed(
          JLPT_TEST_PATH,
          arguments: {JLPT_TEST: words, IS_RANDOM: true},
        );
        break;
      case CategoryEnum.Kangis:
        List<Kangi> kangis = await _createKangiQuiz(level, count, tempKangis);
        Get.offAndToNamed(
          KANGI_TEST_PATH,
          arguments: {KANGI_TEST: kangis, IS_RANDOM: true},
        );
        break;
      case CategoryEnum.Grammars:
        List<Grammar> grammars = await _createGrammarQuiz(
          level,
          count,
          tempGrammars,
        );
        Get.toNamed(
          GRAMMAR_TEST_SCREEN,
          arguments: {'grammar': grammars, IS_RANDOM: true},
        );
    }
  }
}

class QuizCntForm extends StatefulWidget {
  const QuizCntForm({super.key, required this.maxCount});
  final int maxCount;
  @override
  State<QuizCntForm> createState() => _QuizCntFormState();
}

class _QuizCntFormState extends State<QuizCntForm> {
  final TextEditingController teCtl = TextEditingController();

  int maxCount = 100;
  @override
  void initState() {
    super.initState();
    maxCount = widget.maxCount > 100 ? 100 : widget.maxCount;
  }

  String? errorMsg;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '퀴즈 갯수를 입력해주세요',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          CustomTextFormField(
            autofocus: true,
            width: size.width * .4,
            controller: teCtl,
            sufficIcon: Text('개'),
            keyboardType: TextInputType.number,
            hintText: '최대 $maxCount',
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              errorMsg ?? '',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          BottomBtn(
            label: '퀴즈 보기',
            onTap: () {
              String countStr = teCtl.text.trim();
              if (countStr == '' || countStr.isEmpty) {
                setState(() => errorMsg = '갯수를 입력해주세요');
                return;
              }

              int count = int.tryParse(countStr) ?? 0;
              if (count < 4) {
                setState(() => errorMsg = '4개 이상을 입력해주세요.');
                return;
              }
              if (count > maxCount) {
                setState(() => errorMsg = '$maxCount개 이하을 입력해주세요.');
                return;
              }
              Get.back(result: teCtl.text);
            },
          ),
          SizedBox(height: 10),
          Text(
            '랜덤 퀴즈는 점수에 반영되지 않습니다.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
