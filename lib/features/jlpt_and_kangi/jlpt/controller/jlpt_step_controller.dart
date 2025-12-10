import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/common/utils/snackbar_helper.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/jlpt_study/screens/jlpt_study_sceen.dart';
import 'package:jlpt_jonggack/features/jlpt_test/screens/jlpt_test_screen.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';
import 'package:jlpt_jonggack/model/jlpt_step.dart';
import 'package:jlpt_jonggack/model/my_word.dart';
import 'package:jlpt_jonggack/model/word.dart';
import 'package:jlpt_jonggack/repository/jlpt_step_repository.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';

import '../../../../model/Question.dart';

import '../../../../user/controller/user_controller.dart';

class JlptStepController extends GetxController {
  int currChapNumber = 0;

  void toggleAllSave() {
    List<MyWord> myWords =
        getJlptStep().words.map((item) => MyWord.wordToMyWord(item)).toList();
    if (!isAllSave()) {
      MyBookController.to.bulkHandleMyWords(myWords);
    } else {
      MyBookController.to.bulkHandleMyWords(myWords, isAdd: false);
    }

    update();
  }

  bool isAllSave() {
    int savedWordCount = 0;
    for (int i = 0; i < getJlptStep().words.length; i++) {
      Word word = getJlptStep().words[i];

      if (isSavedInLocal(word)) {
        savedWordCount++;
      }
    }

    return savedWordCount == getJlptStep().words.length;
  }

  void toggleSeeMean(bool? v) {
    isSeeMean = !v!;
    update();
  }

  void toggleSeeYomikata(bool? v) {
    isSeeYomikata = !v!;
    update();
  }

  bool isSeeMean = true;
  bool isSeeYomikata = true;
  bool isMoreExample = false;

  void onTapMoreExample() {
    isMoreExample = true;
    update();
  }

  Future<void> goToTest({bool isOffAndToName = false}) async {
    // 테스트를 본 적이 있으면.
    if (getJlptStep().wrongQestion != null &&
        getJlptStep().scores != 0 &&
        getJlptStep().scores != getJlptStep().words.length) {
      bool result = await CommonDialog.askStartToRemainQuestionsDialog();

      if (result) {
        // 과거에 틀린 문제로만 테스트 보기.
        // Get.offAndToNamed(page)
        if (isOffAndToName) {
          Get.offAndToNamed(
            JlptTestScreen.name,
            arguments: {CONTINUTE_JLPT_TEST: getJlptStep().wrongQestion},
          );
        } else {
          Get.toNamed(
            JlptTestScreen.name,
            arguments: {CONTINUTE_JLPT_TEST: getJlptStep().wrongQestion},
          );
        }
        return;
      }
    }
    if (isOffAndToName) {
      Get.offAndToNamed(
        JlptTestScreen.name,
        arguments: {JLPT_TEST: getJlptStep().words, IS_RANDOM: false},
      );
    } else {
      if (getJlptStep().isFinished == null) {
        clearScore();
      } else {
        if (!getJlptStep().isFinished!) {
          clearScore();
        }
      }

      Get.toNamed(
        JlptTestScreen.name,
        arguments: {JLPT_TEST: getJlptStep().words, IS_RANDOM: false},
      );
    }
    // 모든 문제로 테스트 보기.
  }

  void onPageChanged(int page) {
    isMoreExample = false;
    update();
    currentIndex = page;

    update();
  }

  bool isWordSaved = false;
  int currentIndex = 0;
  Word getWord() {
    return getJlptStep().words[currentIndex];
  }

  bool isSavedInLocal(Word word) {
    MyWord newMyWord = MyWord.wordToMyWord(word);
    List<MyWord> book1Words = MyBookController.to.books[0].mywords;

    isWordSaved = book1Words.contains(newMyWord);
    return isWordSaved;
  }

  void toggleSaveWord(Word word, {bool showSnackBar = true}) {
    // if (kDebugMode) {
    //   for (var i = 0; i < 1000; i++) {
    //     final randomeDay = Random().nextInt(90);
    //     DateTime now = DateTime.now();
    //     final dateTime = now.subtract(Duration(days: randomeDay));
    //     final newMyWord = MyWord.wordToMyWordForTest(i, word, dateTime);

    //     MyBookController.to.addMyWord(newMyWord);
    //   }
    // }
    MyWord newMyWord = MyWord.wordToMyWord(word);
    List<MyWord> book1Words = MyBookController.to.books[0].mywords;

    if (book1Words.contains(newMyWord)) {
      MyBookController.to.deleteMyWord(newMyWord);
    } else {
      MyBookController.to.addMyWord(newMyWord);

      if (showSnackBar) {
        SnackBarHelper.showSuccessSnackBar(
          '${word.word}${AppString.savedWord.tr}\n${AppString.checkItAtJGBook.tr}',
        );
      }
    }

    update();
  }

  List<JlptStep> jlptSteps = [];
  final String level;
  late String headTitle;
  late int headTitleCount;
  late int step;

  JlptStepRepositroy jlptStepRepositroy = JlptStepRepositroy();
  UserController userController = Get.find<UserController>();

  JlptStepController({required this.level}) {
    headTitleCount = jlptStepRepositroy.getCountByJlptHeadTitle(level);
  }

  void goToStudyPage(int subStep) {
    setStep(subStep);
    Get.toNamed(JlptStudyScreen.name);
  }

  void setStep(int step) {
    this.step = step;
  }

  /*
   * 테스트로 만점이면 초기화.
   */
  void clearScore() {
    int score = jlptSteps[step].scores;
    jlptSteps[step].scores = 0;
    update();
    jlptStepRepositroy.updateJlptStep(level, jlptSteps[step]);
    userController.updateCurrentProgress(
      TotalProgressType.JLPT,
      int.parse(level) - 1,
      -score,
    );
  }

  void updateScore(int score, List<Question> wrongQestion) {
    // 모든 점수에 해당 점수가 이미 기록 되어 있던가 ?
    int previousScore = jlptSteps[step].scores;

    if (previousScore != 0) {
      userController.updateCurrentProgress(
        TotalProgressType.JLPT,
        int.parse(level) - 1,
        -previousScore,
      );
    }

    score = score + previousScore;

    // 다 맞췄으면
    if (score >= jlptSteps[step].words.length) {
      jlptSteps[step].isFinished = true;
    }
    // 에러 발생.
    else if (score > jlptSteps[step].words.length) {
      score = jlptSteps[step].words.length;
    }

    jlptSteps[step].wrongQestion = wrongQestion;
    jlptSteps[step].scores = score;

    update();

    jlptStepRepositroy.updateJlptStep(level, jlptSteps[step]);
    userController.updateCurrentProgress(
      TotalProgressType.JLPT,
      int.parse(level) - 1,
      score,
    );

    // 처음 보던가
  }

  JlptStep getJlptStep() {
    return jlptSteps[step];
  }

  void setJlptSteps(String headTitle) {
    this.headTitle = headTitle;

    jlptSteps = jlptStepRepositroy.getJlptStepByHeadTitle(
      level,
      this.headTitle,
    );

    currChapNumber = LocalReposotiry.getProgress('Japaneses-$level-$headTitle');

    setStep(currChapNumber);
    update();
  }

  late PageController pageController;

  void finishQuizAndchangeHeaderPageIndex() {
    int currentHeaderPageIndex = LocalReposotiry.getProgress(
      'Japaneses-$level-$headTitle',
    );
    if (currentHeaderPageIndex + 1 == jlptSteps.length) {
      // TODO

      return;
    }
    step = currentHeaderPageIndex + 1;
    getProgress('Japaneses-$level-$headTitle', step);
    pageController.jumpToPage(step);
  }

  void getProgress(String key, int index) {
    LocalReposotiry.setProgress(key, index);
  }

  void changeHeaderPageIndex(int index) {
    step = index;
    getProgress('Japaneses-$level-$headTitle', step);
    pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void sss() {
    currChapNumber = 3;
    update();
  }
}
