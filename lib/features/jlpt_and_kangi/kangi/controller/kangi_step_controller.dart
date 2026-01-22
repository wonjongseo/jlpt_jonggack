import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/common/utils/snackbar_helper.dart';

import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/kangi_test/kangi_test_screen.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/new_add_my_word_screen.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/kangi.dart';
import 'package:jlpt_jonggack/model/kangi_step.dart';
import 'package:jlpt_jonggack/model/my_word.dart';

import 'package:jlpt_jonggack/repository/kangis_step_repository.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';

import '../../../../model/Question.dart';
import '../../../kangi_study/widgets/screens/kangi_study_sceen.dart';
import '../../../../user/controller/user_controller.dart';

class KangiStepController extends GetxController {
  void toggleAllSave() {
    List<MyWord> myWords =
        getKangiStep().kangis
            .map((item) => MyWord.kangiToMyWord(item))
            .toList();
    if (!isAllSave()) {
      MyBookController.to.bulkHandleMyWords(myWords);
    } else {
      MyBookController.to.bulkHandleMyWords(myWords, isAdd: false);
    }

    update();
  }

  bool isAllSave() {
    int savedWordCount = 0;
    for (int i = 0; i < getKangiStep().kangis.length; i++) {
      Kangi kangi = getKangiStep().kangis[i];

      if (isSavedInLocal(kangi)) {
        savedWordCount++;
      }
    }

    return savedWordCount == getKangiStep().kangis.length;
  }

  void toggleSeeMean(bool? v) {
    isHidenMean = v!;
    update();
  }

  void toggleSeeUndoc(bool? v) {
    isHidenUndoc = v!;
    update();
  }

  void toggleSeeHundoc(bool? v) {
    isHidenHundoc = v!;
    update();
  }

  bool isHidenMean = false;
  bool isHidenUndoc = false;
  bool isHidenHundoc = false;

  void onPageChanged(int page) {
    currentIndex = page;
    isWordSaved = false;
    update();
  }

  bool isWordSaved = false;
  bool isSavedInLocal(Kangi kangi) {
    MyWord newMyWord = MyWord.kangiToMyWord(kangi);

    List<MyWord> book1Words = getBook1Words();

    isWordSaved = book1Words.contains(newMyWord);
    return isWordSaved;
  }

  List<MyWord> getBook1Words() {
    return MyBookController.to.books[0].mywords;
  }

  void toggleSaveWord(MyWord newMyWord, {bool showSnackBar = true}) async {
    // MyWord newMyWord = MyWord.wordToMyWord(word);
    List<MyWord> book1Words = MyBookController.to.books[0].mywords;

    if (book1Words.contains(newMyWord)) {
      MyBookController.to.deleteMyWord(newMyWord);
    } else {
      await Get.toNamed(NewAddMyWordScreen.name, arguments: newMyWord);
      // MyBookController.to.addMyWord(newMyWord);

      // if (showSnackBar && SettingController.to.saveWordNoti) {
      //   SnackBarHelper.showSelectableSuccessSnackBar(
      //     '${newMyWord.word} ${AppString.savedWord.tr}\n${AppString.checkItAtJGBook.tr}',
      //   );
      // }
    }

    update();
  }

  Future<void> goToTest({bool isOffAndToName = false}) async {
    if (getKangiStep().wrongQuestion != null &&
        getKangiStep().scores != 0 &&
        getKangiStep().scores != getKangiStep().kangis.length) {
      bool result = await CommonDialog.askStartToRemainQuestionsDialog();

      if (result) {
        // 과거에 틀린 문제로만 테스트 보기.

        if (isOffAndToName) {
          Get.offAndToNamed(
            KangiTestScreen.name,
            arguments: {CONTINUTE_KANGI_TEST: getKangiStep().wrongQuestion},
          );
        } else {
          Get.toNamed(
            KangiTestScreen.name,
            arguments: {CONTINUTE_KANGI_TEST: getKangiStep().wrongQuestion},
          );
        }
        return;
      }
    }
    if (isOffAndToName) {
      Get.offAndToNamed(
        KangiTestScreen.name,
        arguments: {KANGI_TEST: getKangiStep().kangis},
      );
    } else {
      if (getKangiStep().isFinished == null) {
        clearScore();
      } else {
        if (!getKangiStep().isFinished!) {
          clearScore();
        }
      }
      Get.toNamed(
        KangiTestScreen.name,
        arguments: {KANGI_TEST: getKangiStep().kangis},
      );
    }
  }

  int currentIndex = 0;
  Kangi getWord() {
    return getKangiStep().kangis[currentIndex];
  }

  List<KangiStep> kangiSteps = [];
  final String level;
  late String headTitle;
  late int headTitleCount;
  late int step;

  KangiStepRepositroy kangiStepRepository = KangiStepRepositroy();
  UserController userController = Get.find<UserController>();

  KangiStepController({required this.level}) {
    headTitleCount = kangiStepRepository.getCountByHangul(level);
  }

  void setStep(int step) {
    this.step = step;

    if (kangiSteps[step].scores == kangiSteps[step].kangis.length) {
      // clearScore();
    }
  }

  void clearScore() {
    int score = kangiSteps[step].scores;
    kangiSteps[step].scores = 0;
    update();
    kangiStepRepository.updateKangiStep(level, kangiSteps[step]);
    userController.updateCurrentProgress(
      TotalProgressType.KANGI,
      int.parse(level) - 1,
      -score,
    );
  }

  void goToStudyPage(int subStep) {
    setStep(subStep);
    Get.toNamed(KangiStudySceen.name);
  }

  void updateScore(int score, List<Question> wrongQestion) {
    int previousScore = kangiSteps[step].scores;

    if (previousScore != 0) {
      userController.updateCurrentProgress(
        TotalProgressType.KANGI,
        int.parse(level) - 1,
        -previousScore,
      );
    }

    score = score + previousScore;

    if (score >= kangiSteps[step].kangis.length) {
      kangiSteps[step].isFinished = true;
    } else if (score > kangiSteps[step].kangis.length) {
      score = kangiSteps[step].kangis.length;
    }

    kangiSteps[step].wrongQuestion = wrongQestion;
    kangiSteps[step].scores = score;

    update();
    kangiStepRepository.updateKangiStep(level, kangiSteps[step]);
    userController.updateCurrentProgress(
      TotalProgressType.KANGI,
      int.parse(level) - 1,
      score,
    );
  }

  KangiStep getKangiStep() {
    return kangiSteps[step];
  }

  late PageController pageController;

  void setKangiSteps(String headTitle) {
    this.headTitle = headTitle;

    kangiSteps = kangiStepRepository.getKangiStepByHeadTitle(
      level,
      this.headTitle,
    );

    step = LocalReposotiry.getProgress(
      '${CategoryEnum.kangis.name}-$level-$headTitle',
    );
    setStep(step);

    update();
  }

  void finishQuizAndchangeHeaderPageIndex() {
    int currentHeaderPageIndex = LocalReposotiry.getProgress(
      '${CategoryEnum.kangis.name}-$level-$headTitle',
    );
    if (currentHeaderPageIndex + 1 == kangiSteps.length) {
      // TODO

      return;
    }
    step = currentHeaderPageIndex + 1;
    getProgress('${CategoryEnum.kangis.name}-$level-$headTitle', step);
    pageController.jumpToPage(step);
    // pageController.animateToPage(
    //   step,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeIn,
    // );
  }

  void getProgress(String key, int index) {
    LocalReposotiry.setProgress(key, index);
  }

  void changeHeaderPageIndex(int index) {
    step = index;
    getProgress('${CategoryEnum.kangis.name}-$level-$headTitle', step);
    pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }
}
