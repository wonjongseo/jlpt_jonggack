// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/controller/ad_controller.dart';
import 'package:jlpt_jonggack/common/admob/interstitial_manager.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/features/my_voca/services/my_voca_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/new_my_word_controller.dart';
import 'package:jlpt_jonggack/features/score/screens/score_screen.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/jlpt/controller/jlpt_step_controller.dart';
import 'package:jlpt_jonggack/features/score/screens/veryGoodScreen.dart';
import 'package:jlpt_jonggack/features/setting/services/setting_controller.dart';
import 'package:jlpt_jonggack/model/Question.dart';
import 'package:jlpt_jonggack/model/word.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';
import 'package:jlpt_jonggack/services/random_test_generator.dart';

import '../../../common/app_constant.dart';
import '../../../model/my_word.dart';
import '../screens/jlpt_test_screen.dart';
import '../../../user/controller/user_controller.dart';

class JlptTestController extends GetxController
    with SingleGetTickerProviderMixin {
  static JlptTestController get to => Get.find<JlptTestController>();
  @override
  void onInit() {
    animationController = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(animationController)
      ..addListener(() {
        update();
      });

    animationController.forward().whenComplete((nextQuestion));
    pageController = PageController();

    if (settingController.isSubjective) {
      textEditingController = TextEditingController();
      focusNode = FocusNode();
    }

    super.onInit();
  }

  Random random = Random();
  bool isRandom = false;

  int backCnt = 0;

  void init(dynamic arguments) {
    backCnt = arguments['backCnt'] ?? 0;
    if (arguments != null && arguments[MY_VOCA_TEST] != null) {
      // 나만의 시험 초기화
      myVocaController = Get.find<NewMyWordController>();
      startMyVocaQuiz(arguments[MY_VOCA_TEST]);
    } else if (arguments != null && arguments[JLPT_TEST] != null) {
      isRandom = arguments[IS_RANDOM] ?? false;
      startJlptQuiz(arguments[JLPT_TEST]);
    } else {
      // 과거에 틀린 문제로만 테스트 준비하기
      isTestAgain = true;
      startJlptQuizHistory(arguments[CONTINUTE_JLPT_TEST]);
    }
  }

  bool isTestAgain = false;
  late NewMyWordController? myVocaController;

  bool isDisTouchable = false;

  UserController userController = Get.find<UserController>();
  SettingController settingController = Get.find<SettingController>();

  // 진행률 바
  late AnimationController animationController;
  // 진행률 바 애니메이션
  late Animation animation;

  // 문제 컨트롤러
  late PageController pageController;

  // 퀴즈를 위한 맵.
  List<Map<int, List<Word>>> map = List.empty(growable: true);

  late JlptStepController jlptWordController;

  TextEditingController? textEditingController;
  FocusNode? focusNode;
  String? inputValue;

  bool isMyWordTest = false;
  // 읽는 법 값

  bool isWrong = false;
  List<Question> questions = [];
  List<Question> wrongQuestions = [];

  late Word correctQuestion;
  int step = 0;
  bool isAnswered = false;
  int correctAns = 0;
  late int selectedAns;
  RxInt questionNumber = 1.obs;
  int numOfCorrectAns = 0;
  String nextOrSkipText = 'skip';
  Color color = Colors.black;

  void toggleSubjective() {
    SettingController.to.toggleSubjective();
    if (SettingController.to.isSubjective) {
      textEditingController = TextEditingController(text: inputValue);
    } else {
      textEditingController = null;
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    pageController.dispose();
    textEditingController?.dispose();
    focusNode?.dispose();

    super.onClose();
  }

  void manualSaveToMyVoca(int index) {
    if (isMyWordTest) {
      return;
    }
    if (MyWord.saveToMyVoca(wrongQuestions[index].question)) {
      userController.updateMyWordSavedCount(true);
    }
    jlptWordController.update();
  }

  void startJlptQuiz(List<Word> words) {
    jlptWordController = Get.find<JlptStepController>();
    map = Question.generateQustion(words);
    // 테스트 다시 시작한 것이기 때문에,
    // 기존에 저장 되어 있는 점수 초기화.
    if (!isRandom) {
      jlptWordController.getJlptStep().scores = 0;
    }

    setQuestions();
  }

  void startMyVocaQuiz(List<MyWord> myWords) {
    isMyWordTest = true;

    List<Word> tempWords = List.generate(
      myWords.length,
      (i) => Word(
        word: myWords[i].word,
        mean: myWords[i].mean,
        yomikata: myWords[i].yomikata ?? '',
        headTitle: '',
      ),
    );

    // map = Question.generateQustion(tempWords);
    // print("object");
    setQuestions2(tempWords);
  }

  void startJlptQuizHistory(List<Question> wrongQuestions) {
    jlptWordController = Get.find<JlptStepController>();
    questions = wrongQuestions;

    questions.shuffle();
    for (int i = 0; i < questions.length; i++) {
      questions[i].options.shuffle();
    }
    for (int i = 0; i < questions.length; i++) {
      for (int j = 0; j < questions[i].options.length; j++) {
        if (questions[i].question.word == questions[i].options[j].word) {
          questions[i].answer = j;
          break;
        }
      }
    }
  }

  bool isSubmittedYomikata = false;

  void onFieldSubmitted(String value) {
    if (value.isEmpty) return;
    inputValue = value;
    isSubmittedYomikata = true;
  }

  void setQuestions() {
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
  }

  void setQuestions2(List<Word> words) async {
    List<Word> baseWords = List.from(words);

    int needed = baseWords.length - 4;
    List<Word> extraWords = [];
    if (needed < 0) {
      // final wordRepo = Get.find<HiveRepository<Word>>(tag: Word.boxKey);
      List<Word> allWords = await RandomTestGenerator.getAllJapaneseByLevel(
        1,
        false,
      );

      for (int i = 0; i < -needed; i++) {
        int randomIndex = random.nextInt(allWords.length);
        baseWords.add(allWords[randomIndex]);
        extraWords.add(allWords[randomIndex]);
      }
    }

    map = Question.generateQustion(baseWords);

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

    if (extraWords.isNotEmpty) {
      questions.removeWhere((question) {
        Word? word = extraWords.firstWhereOrNull(
          (tWord) => tWord.word == question.question.word,
        );
        return word != null;
      });
    }
    for (var i = 0; i < questions.length; i++) {
      final q = questions[i];
      print('${i + 1}번 : ${q.answer + 1}');
    }
  }

  void saveWrongQuestion() {
    if (!wrongQuestions.contains(questions[questionNumber.value - 1])) {
      wrongQuestions.add(questions[questionNumber.value - 1]);
    }
  }

  Color getTheTextEditerBorderRightColor({bool isBorder = true}) {
    if (isAnswered) {
      if (formattingQuestion(correctQuestion.yomikata, inputValue!)) {
        return const Color(0xFF6AC259);
      } else {
        return const Color(0xFFE92E30);
      }
    }
    return isBorder
        ? AppColors.scaffoldBackground.withOpacity(0.5)
        : AppColors.scaffoldBackground;
  }

  void requestFocus() {
    focusNode?.requestFocus();
  }

  // 사지선다 눌렀을 경우.
  void checkAns(Question question, int selectedIndex) {
    if (settingController.isSubjective) {
      if (!isSubmittedYomikata) return;
    }
    isDisTouchable = true;

    correctAns = question.answer;
    selectedAns = selectedIndex;
    isAnswered = true;

    correctQuestion = question.options[correctAns];

    if (settingController.isSubjective) {
      if (textEditingController!.text.isEmpty) {
        requestFocus();
        return;
      }
    }

    animationController.stop();
    update();

    // if 설정에서 읽는법도 테스트에 포함
    if (settingController.isSubjective) {
      if (correctAns == selectedAns &&
          formattingQuestion(correctQuestion.yomikata, inputValue!)) {
        testCorect();
      } else {
        textWrong();
      }
    }
    // if 설정에서 읽는법도 테스트에 포함하지 않았나.
    else if (correctAns == selectedAns) {
      testCorect();
    } else {
      textWrong();
    }
  }

  textWrong() {
    if (isMyWordTest) {
      myVocaController!.updateWord(correctQuestion.word, false);
    }
    saveWrongQuestion();
    isWrong = true;
    color = Colors.pink;
    nextOrSkipText = 'next';
    Future.delayed(const Duration(milliseconds: 1500), () {
      nextQuestion();
    });
  }

  testCorect() {
    nextOrSkipText = 'skip';
    numOfCorrectAns++;
    color = Colors.blue;
    nextOrSkipText = 'next';
    if (isMyWordTest) {
      // 나만의 단어 알고 있음으로 변경.
      myVocaController!.updateWord(correctQuestion.word, true);
    }
    Future.delayed(const Duration(milliseconds: 1200), () {
      nextQuestion();
    });
  }

  bool formattingQuestion(String correct, String answer) {
    correct.trim();

    answer.trim();

    correct = correct.replaceAll('-', '');
    correct = correct.replaceAll('ー', '');
    correct = correct.replaceAll('　', '');
    correct = correct.replaceAll(' ', '');

    answer = answer.replaceAll('-', '');
    answer = answer.replaceAll('ー', '');
    answer = answer.replaceAll(' ', '');
    answer = answer.replaceAll('　', '');

    return answer == correct;
  }

  void skipQuestion() {
    isDisTouchable = false;
    // update();
    isAnswered = true;

    animationController.stop();
    saveWrongQuestion();
    isWrong = true;
    color = Colors.pink;
    nextOrSkipText = 'next';
    nextQuestion();
  }

  void nextQuestion() {
    isSubmittedYomikata = false;
    isDisTouchable = false;
    inputValue = '';
    if (questionNumber.value != questions.length) {
      if (!isAnswered) {
        saveWrongQuestion();
      }
      isWrong = false;
      nextOrSkipText = 'skip';
      color = Colors.black;
      isAnswered = false;

      textEditingController?.clear();

      pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );

      animationController.reset();
      animationController.forward().whenComplete(nextQuestion);
    }
    // 테스트를 다 풀 었으면
    else {
      for (var i = 0; i < backCnt; i++) {
        Get.back();
      }
      if (!isTestAgain) {
        InterstitialManager.instance.maybeShow();
      }

      bool isRecordData = !isRandom && !isMyWordTest;

      if (isRecordData) {
        bool? isFinished = jlptWordController.getJlptStep().isFinished;
        if (isFinished == null) {
          jlptWordController.updateScore(numOfCorrectAns, wrongQuestions);
        } else {
          if (!isFinished) {
            jlptWordController.updateScore(numOfCorrectAns, wrongQuestions);
          }
        }
      } else {
        // if (isMyWordTest) {
        //   Get.back();
        // }
      }

      if (numOfCorrectAns == questions.length) {
        if (isRecordData) {
          jlptWordController.finishQuizAndchangeHeaderPageIndex();
        }
        if (!isMyWordTest) {
          Get.off(() => const VeryGoodScreen());
        } else {
          Get.back();
          Get.to(() => const VeryGoodScreen());
        }
        return;
      }

      if (isRandom) {
        Get.back();
        Get.toNamed(SCORE_PATH);
      } else {
        Get.offAndToNamed(SCORE_PATH);
      }
    }
  }

  void updateTheQnNum(int index) {
    questionNumber.value = index + 1;
  }

  String get scoreResult => '$numOfCorrectAns / ${questions.length}';

  String wrongMean(int index) {
    return '${wrongQuestions[index].options[wrongQuestions[index].answer].mean}\n${wrongQuestions[index].options[wrongQuestions[index].answer].yomikata}';
  }

  String wrongWord(int index) {
    return wrongQuestions[index].question.word;
  }
}
