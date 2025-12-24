import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/interstitial_manager.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';
import 'package:jlpt_jonggack/features/new_grmmar/controllers/new_grammar_controller.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/new_grammar_test_screen.dart';

import 'package:jlpt_jonggack/model/example.dart';
import 'package:jlpt_jonggack/model/grammar.dart';
import 'package:jlpt_jonggack/model/grammar_question.dart';
import 'package:jlpt_jonggack/model/grammar_step.dart';
import 'package:jlpt_jonggack/model/my_word.dart';
import 'package:jlpt_jonggack/repository/grammar_step_repository.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

class NewGrammarTestController extends GetxController {
  GrammarStep _grammarStep;
  // final List<Grammar> grammars;
  final bool isRandom;
  final bool isTestAgain;
  final bool isRecord;
  final bool isMyWord;

  NewGrammarTestController(
    this._grammarStep,
    this.isRandom,
    this.isTestAgain,
    this.isRecord,
    this.isMyWord,
  );

  final scrollController = ScrollController();
  final repository = GrammarRepositroy();

  final questions = <GrammarQuestion>[].obs;

  List<Map<int, List<GrammarQustionWord>>> map = List.empty(growable: true);

  final _isSubmitted = false.obs;
  bool get isSubmitted => _isSubmitted.value;

  /// 실제로 시험보는 문제들
  final quizGrammars = <Grammar>[].obs;

  @override
  void onInit() {
    _initTest();

    super.onInit();
  }

  final answers = <int?>[].obs;

  List<int> get unansweredIdxs =>
      List<int>.generate(
        questions.length,
        (i) => i,
      ).where((i) => answers[i] == null).toList();

  List<int> get wrongIdxs =>
      List<int>.generate(questions.length, (i) => i)
          .where((i) => answers[i] == null || answers[i] != questions[i].answer)
          .toList();

  List<int> get correctIdxs =>
      List<int>.generate(questions.length, (i) => i)
          .where((i) => answers[i] != null && answers[i] == questions[i].answer)
          .toList();

  List<Grammar> get correctGrammars =>
      correctIdxs
          .map((i) => questions[i].question.originGrammar)
          .toSet()
          .toList();
  List<Grammar> get wrongGrammars =>
      wrongIdxs
          .map((i) => questions[i].question.originGrammar)
          .toSet()
          .toList();

  double get getCurrentProgressValue {
    final total = questions.length;
    if (total == 0) return 0;
    final answered = answers.where((e) => e != null).length;

    return (answered / total) * 100;
  }

  double getScore() {
    final total = questions.length;
    if (total == 0) return 0;
    return (correctIdxs.length / total) * 100;
  }

  void submit() async {
    // double score = getScore();
    final remain = unansweredIdxs;
    if (remain.isNotEmpty) {
      final remainQuestions = remain.map((i) => '${i + 1}').toString();
      if (!await CommonDialog.confirmToSubmitGrammarTest(remainQuestions)) {
        return;
      }
    }

    InterstitialManager.instance.maybeShow();
    _isSubmitted.value = true;
    scrollController.jumpTo(0);

    if (isMyWord) {
      for (var g in wrongGrammars) {
        final myWord = MyWord.grammerToWord(g);
        myWord.isKnown = false;
        MyBookController.to.updateMyWord(myWord);
      }

      for (var g in correctGrammars) {
        final myWord = MyWord.grammerToWord(g);
        myWord.isKnown = true;
        MyBookController.to.updateMyWord(myWord);
      }
    }
    if (isRecord) {
      saveScore();
    }
  }

  void saveScore() async {
    if (_grammarStep.isFinished ?? false) return;

    final levelIdx = int.parse(NewGrammarController.to.level) - 1;

    int prevScore = _grammarStep.scores;
    final correctThisAttempt = correctIdxs.length; // ✅ 확정된 정답 수

    final newScore =
        isTestAgain ? prevScore + correctThisAttempt : correctThisAttempt;

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
    // ✅ 오답이 있으면 저장 (전부 틀린 케이스도 포함)
    if (wrongGrammars.isNotEmpty) {
      // _grammarStep = _grammarStep.copyWith(unKnownGrammars: wrongGrammars);
      // await repository.updateGrammerStep(_grammarStep);
      await NewGrammarController.to.getDatas();
    }
  }

  void clickButton(int quizIndex, int selectedIndex) {
    answers[quizIndex] = selectedIndex; // ✅ 이 한 줄로 끝
  }

  void _initTest() {
    quizGrammars.assignAll(_grammarStep.grammars);

    if (isTestAgain) {
      quizGrammars.assignAll(_grammarStep.unKnownGrammars);
    }

    Random random = Random();

    List<GrammarQustionWord> questionGrammar = [];

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

      questionGrammar.add(tempWord);
    }

    map = GrammarQuestion.generateQustion(questionGrammar);

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

    answers.assignAll(List<int?>.filled(questions.length, null));
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

// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jlpt_jonggack/common/admob/interstitial_manager.dart';
// import 'package:jlpt_jonggack/common/commonDialog.dart';
// import 'package:jlpt_jonggack/features/new_grmmar/controllers/new_grammar_controller.dart';
// import 'package:jlpt_jonggack/features/new_grmmar/screen/new_grammar_test_screen.dart';

// import 'package:jlpt_jonggack/model/example.dart';
// import 'package:jlpt_jonggack/model/grammar.dart';
// import 'package:jlpt_jonggack/model/grammar_question.dart';
// import 'package:jlpt_jonggack/model/grammar_step.dart';
// import 'package:jlpt_jonggack/model/my_word.dart';
// import 'package:jlpt_jonggack/repository/grammar_step_repository.dart';
// import 'package:jlpt_jonggack/repository/my_word_repository.dart';
// import 'package:jlpt_jonggack/user/controller/user_controller.dart';

// class NewGrammarTestController extends GetxController {
//   GrammarStep _grammarStep;
//   // final List<Grammar> grammars;
//   final bool isRandom;
//   final bool isTestAgain;
//   final bool isRecord;

//   NewGrammarTestController(
//     this._grammarStep,
//     this.isRandom,
//     this.isTestAgain,
//     this.isRecord,
//   );

//   final scrollController = ScrollController();
//   final repository = GrammarRepositroy();

//   final questions = <GrammarQuestion>[].obs;

//   List<Map<int, List<GrammarQustionWord>>> map = List.empty(growable: true);

//   List<Grammar> _wrongGrammar = [];
//   final _isSubmitted = false.obs;
//   bool get isSubmitted => _isSubmitted.value;

//   /// 실제로 시험보는 문제들
//   final quizGrammars = <Grammar>[].obs;

//   // 틀린 문제
//   final wrongQuizIdxs = <int>[].obs;
//   // 선택된 인덱스
//   final unCheckedQuizIdxs = <int>[].obs;

//   @override
//   void onInit() {
//     _initTest();

//     super.onInit();
//   }

//   double get getCurrentProgressValue {
//     final total = questions.length;
//     if (total == 0) return 0;
//     return ((total - unCheckedQuizIdxs.length) / total) * 100;
//   }

//   double getScore() {
//     final total = questions.length;
//     if (total == 0) return 0;
//     return ((total - wrongQuizIdxs.length) / total) * 100;
//   }

//   void submit() async {
//     // double score = getScore();
//     if (unCheckedQuizIdxs.isNotEmpty) {
//       String remainQuestions =
//           unCheckedQuizIdxs.map((e) => '${e + 1}').toString();

//       if (!await CommonDialog.confirmToSubmitGrammarTest(remainQuestions)) {
//         return;
//       }
//     }

//     InterstitialManager.instance.maybeShow();
//     _isSubmitted.value = true;
//     scrollController.jumpTo(0);

//     if (isRecord) {
//       saveScore();
//     }
//   }

//   void saveScore() async {
//     if (_grammarStep.isFinished ?? false) return;

//     final levelIdx = int.parse(NewGrammarController.to.level) - 1;

//     int prevScore = _grammarStep.scores;
//     int correctThisAttemp = quizGrammars.length - wrongQuizIdxs.length;

//     int newScore =
//         isTestAgain ? prevScore + correctThisAttemp : correctThisAttemp;

//     final maxScore = _grammarStep.grammars.length;

//     final clampedNewScore = newScore.clamp(0, maxScore);

//     final delta = clampedNewScore - prevScore;
//     _grammarStep.scores = clampedNewScore;
//     _grammarStep.isFinished = (clampedNewScore == maxScore);

//     repository.updateGrammerStep(_grammarStep);

//     if (delta != 0) {
//       UserController.to.updateCurrentProgress(
//         TotalProgressType.GRAMMAR,
//         levelIdx,
//         delta,
//       );
//     }
//     if (wrongQuizIdxs.isNotEmpty &&
//         wrongQuizIdxs.length != quizGrammars.length) {
//       _saveWrongQuiz();

//       await NewGrammarController.to.getDatas();
//     }
//   }

//   void _saveWrongQuiz() async {
//     _grammarStep = _grammarStep.copyWith(unKnownGrammars: _wrongGrammar);

//     await repository.updateGrammerStep(_grammarStep);
//   }

//   void clickButton(int quizIndex, int selectedIndex) {
//     final question = questions[quizIndex];
//     final grammar = question.question.originGrammar;
//     int correctAns = question.answer;

//     if (correctAns == selectedIndex) {
//       wrongQuizIdxs.remove(quizIndex);
//       _wrongGrammar.remove(grammar);
//     } else {
//       if (!wrongQuizIdxs.contains(quizIndex)) {
//         wrongQuizIdxs.add(quizIndex);
//       }
//       if (!_wrongGrammar.contains(grammar)) {
//         _wrongGrammar.add(grammar);
//       }
//     }
//     unCheckedQuizIdxs.remove(quizIndex);
//   }

//   ///

//   void _initTest() {
//     _startGrammarTest();
//   }

//   void _startGrammarTest() {
//     print('_startGrammarTest');
//     print('_grammarStep.grammars.length : ${_grammarStep.grammars.length}');

//     quizGrammars.assignAll(_grammarStep.grammars);

//     if (isTestAgain) {
//       quizGrammars.assignAll(_grammarStep.unKnownGrammars);
//     }

//     Random random = Random();

//     List<GrammarQustionWord> words = [];

//     for (int i = 0; i < quizGrammars.length; i++) {
//       print('i : ${i}');

//       List<Example> examples = quizGrammars[i].examples;

//       if (examples.isEmpty) continue;

//       int randomExampleIndex = random.nextInt(examples.length);
//       String word = examples[randomExampleIndex].word;

//       word = word
//           .replaceAll('<span class="bold">', '')
//           .replaceAll('</span>', '');

//       String answer = examples[randomExampleIndex].answer!;

//       word = word.replaceAll(answer, '_____');

//       String yomikata = examples[randomExampleIndex].mean;

//       final tempWord = GrammarQustionWord(
//         word: word,
//         mean: answer,
//         yomikata: yomikata,
//         originGrammar: quizGrammars[i],
//       );

//       words.add(tempWord);
//     }

//     map = GrammarQuestion.generateQustion(words);

//     _setQuestions();
//   }

//   void _setQuestions() {
//     for (var grammars in map) {
//       for (var e in grammars.entries) {
//         List<GrammarQustionWord> optionsVoca = e.value;
//         GrammarQustionWord questionVoca = optionsVoca[e.key];

//         GrammarQuestion question = GrammarQuestion(
//           question: questionVoca,
//           answer: e.key,
//           options: optionsVoca,
//         );

//         questions.add(question);
//       }
//     }
//     for (int i = 0; i < questions.length; i++) {
//       print('${i + 1} ${questions[i].answer + 1}');
//     }

//     wrongQuizIdxs.assignAll(List.generate(questions.length, (index) => index));
//     unCheckedQuizIdxs.assignAll(
//       List.generate(questions.length, (index) => index),
//     );
//   }

//   void againTest() {
//     Get.offNamed(
//       NewGrammarTestScreen.name,
//       preventDuplicates: false,
//       arguments: {
//         'grammarStep': _grammarStep,
//         'isTestAgain': true,
//         'isRandom': isRandom,
//       },
//     );
//   }
// }
