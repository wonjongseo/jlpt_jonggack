import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/interstitial_manager.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/features/new_grmmar/controllers/new_grammar_controller.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/new_grammar_test_screen.dart';
import 'package:jlpt_jonggack/model/Question.dart';
import 'package:jlpt_jonggack/model/example.dart';
import 'package:jlpt_jonggack/model/grammar.dart';
import 'package:jlpt_jonggack/model/grammar_step.dart';
import 'package:jlpt_jonggack/model/word.dart';
import 'package:jlpt_jonggack/repository/grammar_step_repository.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

class NewGrammarTestController extends GetxController {
  GrammarStep _grammarStep;
  // final List<Grammar> grammars;
  final bool isRandom;
  final bool isTestAgain;
  NewGrammarTestController(this._grammarStep, this.isRandom, this.isTestAgain);

  final scrollController = ScrollController();
  final repository = GrammarRepositroy();

  final questions = <Question>[].obs;

  List<Map<int, List<Word>>> map = List.empty(growable: true);

  final _isSubmitted = false.obs;
  bool get isSubmitted => _isSubmitted.value;

  /// 실제로 시험보는 문제들
  final quizGrammars = <Grammar>[].obs;

  // 틀린 문제
  final wrongQuizIdxs = <int>[].obs;
  // 선택된 인덱스
  final checkedQuizIdxs = <int>[].obs;

  @override
  void onInit() {
    _initTest();

    super.onInit();
  }

  double get getCurrentProgressValue {
    final total = questions.length;
    if (total == 0) return 0;
    return ((total - checkedQuizIdxs.length) / total) * 100;
  }

  double getScore() {
    final total = questions.length;
    if (total == 0) return 0;
    return ((total - wrongQuizIdxs.length) / total) * 100;
  }

  void submit() async {
    // double score = getScore();
    if (checkedQuizIdxs.isNotEmpty) {
      String remainQuestions =
          checkedQuizIdxs.map((e) => '${e + 1}').toString();

      if (!await CommonDialog.confirmToSubmitGrammarTest(remainQuestions)) {
        return;
      }
    }

    saveScore();
    InterstitialManager.instance.maybeShow();
    _isSubmitted.value = true;
    scrollController.jumpTo(0);

    if (wrongQuizIdxs.isNotEmpty &&
        wrongQuizIdxs.length != quizGrammars.length) {
      _saveWrongQuiz();
    }
  }

  void saveScore() {
    if (_grammarStep.isFinished ?? false) return;

    final levelIdx = int.parse(NewGrammarController.to.level) - 1;

    int prevScore = _grammarStep.scores;
    int correctThisAttemp = quizGrammars.length - wrongQuizIdxs.length;

    int newScore =
        isTestAgain ? prevScore + correctThisAttemp : correctThisAttemp;

    final maxScore = _grammarStep.grammars.length;

    final clampedNewScore = newScore.clamp(0, maxScore);

    final delta = clampedNewScore - prevScore;
    _grammarStep.scores = clampedNewScore;
    _grammarStep.isFinished = (clampedNewScore == maxScore);

    repository.updateGrammerStep(_grammarStep);

    if (delta != 0) {
      UserController.to.updateCurrentProgress(
        TotalProgressType.GRAMMAR,
        levelIdx,
        delta,
      );
    }
  }

  void _saveWrongQuiz() async {
    List<Grammar> unKnownGrammars =
        wrongQuizIdxs.map((i) => quizGrammars[i]).toList();

    _grammarStep = _grammarStep.copyWith(unKnownGrammars: unKnownGrammars);

    await repository.updateGrammerStep(_grammarStep);

    await NewGrammarController.to.getDatas();
  }

  void clickButton(int quizIndex, int selectedIndex) {
    final question = questions[quizIndex];
    int correctAns = question.answer;

    if (correctAns == selectedIndex) {
      wrongQuizIdxs.remove(quizIndex);
    } else {
      if (!wrongQuizIdxs.contains(quizIndex)) {
        wrongQuizIdxs.add(quizIndex);
      }
    }
    checkedQuizIdxs.remove(quizIndex);
  }

  ///

  void _initTest() {
    _startGrammarTest();
  }

  void _startGrammarTest() {
    quizGrammars.assignAll(_grammarStep.grammars);

    if (isTestAgain) {
      print(
        '_grammarStep.unKnownGrammars.length : ${_grammarStep.unKnownGrammars.length}',
      );

      quizGrammars.assignAll(_grammarStep.unKnownGrammars);
    }

    print('quizGrammars.length : ${quizGrammars.length}');

    Random random = Random();

    List<Word> words = [];

    for (int i = 0; i < quizGrammars.length; i++) {
      List<Example> examples = quizGrammars[i].examples;

      if (examples.isEmpty) continue;

      int randomExampleIndex = random.nextInt(examples.length);
      String word = examples[randomExampleIndex].word;

      word = word.replaceAll('<span class=\"bold\">', '');
      word = word.replaceAll('</span>', '');

      String answer = examples[randomExampleIndex].answer!;

      if (word.contains('<span class=\"bold\">') && word.contains('</span>')) {
        String pattern = '<span class="bold">';
        bool result = _containsMoreThanOnce(word, pattern);
        if (result) {
          word = word.replaceAll(answer, '_____');
        } else {
          word = word.replaceAll(answer, '_____');
          List<String> tt = word.split('<span class=\"bold\">');
          word = "${tt[0]}_____${tt[1].split('</span>')[1]}";
        }
      } else {
        word = word.replaceAll(answer, '_____');
      }

      String yomikata = examples[randomExampleIndex].mean;

      Word tempWord = Word(
        word: word,
        mean: answer,
        yomikata: yomikata,
        headTitle: quizGrammars[i].level,
      );

      words.add(tempWord);
    }

    map = Question.generateQustion(words);
    _setQuestions();
  }

  void _setQuestions() {
    for (var vocas in map) {
      for (var e in vocas.entries) {
        List<Word> optionsVoca = e.value;
        Word questionVoca = optionsVoca[e.key];

        Question question = Question(
          question: questionVoca,
          answer: e.key,
          options: optionsVoca,
        );

        questions.add(question);
      }
    }
    for (int i = 0; i < questions.length; i++) {
      print('${i + 1} ${questions[i].answer + 1}');
    }

    questions.shuffle();
    wrongQuizIdxs.assignAll(List.generate(questions.length, (index) => index));
    checkedQuizIdxs.assignAll(
      List.generate(questions.length, (index) => index),
    );
  }

  bool _containsMoreThanOnce(String str, String pattern) {
    RegExp regExp = RegExp(pattern);
    Iterable<RegExpMatch> matches = regExp.allMatches(str);
    return matches.length >= 2;
  }

  void againTest() {
    Get.offNamed(
      NewGrammarTestScreen.name,
      preventDuplicates: false,
      arguments: {
        'grammarStep': _grammarStep,
        'isTestAgain': true,
        'isRandom': isRandom,
      },
    );
  }
}


 // final result = await Get.dialog(
      //   AlertDialog.adaptive(
      //     content: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Text('남은 문제가 있습니다.'),
      //         Text(unSelectedAnswers.toString()),
      //         Text('그래도 제출하시곘습니까 ?'),
      //       ],
      //     ),
      //     actions: [
      //       TextButton(
      //         onPressed: () => Get.back(result: true),
      //         child: Text('네'),
      //       ),
      //       TextButton(
      //         onPressed: () => Get.back(result: false),
      //         child: Text('아니요'),
      //       ),
      //     ],
      //   ),
      // );
      // if (result == false) {
      //   return;
      // }