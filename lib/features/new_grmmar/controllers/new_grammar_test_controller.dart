import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/interstitial_manager.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/features/new_grmmar/controllers/new_grammar_controller.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/new_grammar_test_screen.dart';

import 'package:jlpt_jonggack/model/example.dart';
import 'package:jlpt_jonggack/model/grammar.dart';
import 'package:jlpt_jonggack/model/grammar_question.dart';
import 'package:jlpt_jonggack/model/grammar_step.dart';
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

  final questions = <GrammarQuestion>[].obs;

  List<Map<int, List<GrammarQustionWord>>> map = List.empty(growable: true);

  List<Grammar> _wrongGrammar = [];
  final _isSubmitted = false.obs;
  bool get isSubmitted => _isSubmitted.value;

  /// 실제로 시험보는 문제들
  final quizGrammars = <Grammar>[].obs;

  // 틀린 문제
  final wrongQuizIdxs = <int>[].obs;
  // 선택된 인덱스
  final unCheckedQuizIdxs = <int>[].obs;

  @override
  void onInit() {
    _initTest();

    super.onInit();
  }

  double get getCurrentProgressValue {
    final total = questions.length;
    if (total == 0) return 0;
    return ((total - unCheckedQuizIdxs.length) / total) * 100;
  }

  double getScore() {
    final total = questions.length;
    if (total == 0) return 0;
    return ((total - wrongQuizIdxs.length) / total) * 100;
  }

  void submit() async {
    // double score = getScore();
    if (unCheckedQuizIdxs.isNotEmpty) {
      String remainQuestions =
          unCheckedQuizIdxs.map((e) => '${e + 1}').toString();

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

      await NewGrammarController.to.getDatas();
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
    _grammarStep = _grammarStep.copyWith(unKnownGrammars: _wrongGrammar);

    await repository.updateGrammerStep(_grammarStep);
  }

  void clickButton(int quizIndex, int selectedIndex) {
    final question = questions[quizIndex];
    final grammar = question.question.originGrammar;
    int correctAns = question.answer;

    if (correctAns == selectedIndex) {
      wrongQuizIdxs.remove(quizIndex);
      _wrongGrammar.remove(grammar);
    } else {
      if (!wrongQuizIdxs.contains(quizIndex)) {
        wrongQuizIdxs.add(quizIndex);
      }
      if (!_wrongGrammar.contains(grammar)) {
        _wrongGrammar.add(grammar);
      }
    }
    unCheckedQuizIdxs.remove(quizIndex);
  }

  ///

  void _initTest() {
    _startGrammarTest();
  }

  void _startGrammarTest() {
    quizGrammars.assignAll(_grammarStep.grammars);

    if (isTestAgain) {
      quizGrammars.assignAll(_grammarStep.unKnownGrammars);
    }

    Random random = Random();

    List<GrammarQustionWord> words = [];

    for (int i = 0; i < quizGrammars.length; i++) {
      List<Example> examples = quizGrammars[i].examples;

      if (examples.isEmpty) continue;

      int randomExampleIndex = random.nextInt(examples.length);
      String word = examples[randomExampleIndex].word;

      word = word
          .replaceAll('<span class="bold">', '')
          .replaceAll('</span>', '');

      String answer = examples[randomExampleIndex].answer!;

      word = word.replaceAll(answer, '_____');

      String yomikata = examples[randomExampleIndex].mean;

      final tempWord = GrammarQustionWord(
        word: word,
        mean: answer,
        yomikata: yomikata,
        originGrammar: quizGrammars[i],
      );

      words.add(tempWord);
    }

    map = GrammarQuestion.generateQustion(words);

    _setQuestions();
  }

  void _setQuestions() {
    for (var grammars in map) {
      for (var e in grammars.entries) {
        List<GrammarQustionWord> optionsVoca = e.value;
        GrammarQustionWord questionVoca = optionsVoca[e.key];

        GrammarQuestion question = GrammarQuestion(
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

    wrongQuizIdxs.assignAll(List.generate(questions.length, (index) => index));
    unCheckedQuizIdxs.assignAll(
      List.generate(questions.length, (index) => index),
    );
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