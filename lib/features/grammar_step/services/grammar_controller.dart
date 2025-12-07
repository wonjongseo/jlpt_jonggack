import 'package:get/get.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';
import 'package:jlpt_jonggack/model/grammar_step.dart';
import 'package:jlpt_jonggack/model/my_word.dart';
import 'package:jlpt_jonggack/repository/grammar_step_repository.dart';

import '../../../user/controller/user_controller.dart';

class GrammarStepController extends GetxController {
  static GrammarStepController get to => Get.find<GrammarStepController>();
  late final Rx<GrammarStep> _grammars;
  late final RxList<bool> isSaveds;
  GrammarStep get grammarStep => _grammars.value;

  GrammarStepController(this.lebel, this.chapter, GrammarStep grammarStep)
    : _grammars = grammarStep.obs,
      isSaveds = List.filled(grammarStep.grammars.length, false).obs;

  @override
  void onInit() {
    super.onInit();
    for (var i = 0; i < _grammars.value.grammars.length; i++) {
      final grammer = _grammars.value.grammars[i];
      isSaveds[i] = MyBookController.to.isSavedInJgBook(
        MyWord.grammerToWord(grammer),
      );
    }
  }

  void toggleSaved(int index) {
    final grammar = _grammars.value.grammars[index];
    final savedGrammar = MyWord.grammerToWord(grammar);
    if (isSaveds[index]) {
      isSaveds[index] = false;
      MyBookController.to.deleteMyWord(savedGrammar);
    } else {
      isSaveds[index] = true;
      MyBookController.to.addMyWord(savedGrammar);
    }
  }

  final String lebel;
  final String chapter;
}

class GrammarController extends GetxController {
  List<GrammarStep> grammers = [];
  late int step;
  late String level;
  final grammarRepositroy = GrammarRepositroy();

  bool isSeeMean = true;

  void isSaved() {}

  void toggleSeeMean(bool? v) {
    isSeeMean = !v!;
    update();
  }

  int clickedIndex = 0;
  UserController userController = Get.find<UserController>();

  GrammarController({required this.level}) {
    grammers = grammarRepositroy.getGrammarStepByLevel(level);
  }

  void setStep(int step) {
    this.step = step;
  }

  void updateScore(int score, {bool isRetry = false}) {
    if (grammers[step].isFinished ?? false) {
      return;
    }
    int previousScore = grammers[step].scores;

    if (previousScore != 0) {
      userController.updateCurrentProgress(
        TotalProgressType.GRAMMAR,
        int.parse(level) - 1,
        -previousScore,
      );
    }

    if (score == grammers[step].grammars.length) {
      grammers[step].isFinished = true;
    } else if (score > grammers[step].grammars.length) {
      score = grammers[step].grammars.length;
    }

    grammers[step].scores = score;
    update();
    grammarRepositroy.updateGrammerStep(grammers[step]);

    userController.updateCurrentProgress(
      TotalProgressType.GRAMMAR,
      int.parse(level) - 1,
      score,
    );
  }

  // GrammarStep get grammarStep => grammers[step];
}
