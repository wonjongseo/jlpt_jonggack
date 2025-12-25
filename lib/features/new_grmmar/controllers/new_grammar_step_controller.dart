import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/common/utils/snackbar_helper.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/grammar_step/widgets/gammar_card_details.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/new_grammar_test_screen.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/grammar_step.dart';
import 'package:jlpt_jonggack/model/my_word.dart';

class NewGrammarStepController extends GetxController {
  final String chapter;
  final GrammarStep grammarStep;

  final isHideMeanIdxs = <bool>[].obs;
  // final isSavedGrammars = <bool>[].obs;
  late final RxList<bool> isSaveds;

  final _isHideMean = false.obs;
  bool get isHideMean => _isHideMean.value;

  void toggleHideMean(bool value) {
    _isHideMean.value = !_isHideMean.value;
    if (_isHideMean.value) {
      isHideMeanIdxs.assignAll(isHideMeanIdxs.map((_) => true).toList());
    } else {
      isHideMeanIdxs.assignAll(isHideMeanIdxs.map((_) => false).toList());
    }
  }

  void toggleHideMeanByIdx(int index) {
    isHideMeanIdxs[index] = !isHideMeanIdxs[index];
  }

  NewGrammarStepController(this.grammarStep, this.chapter)
    : isSaveds = List.filled(grammarStep.grammars.length, false).obs;

  void goToDetailScreen(GrammarStep grammerStep, int index) {
    Get.to(() => GrammarCardDetails(grammerStep: grammerStep, index: index));
    // Get.toNamed(NewGrammarCardDetail.name, arguments: index);
  }

  void goToTestScreen() async {
    bool isTextAgain = grammarStep.unKnownGrammars.isNotEmpty;
    if (isTextAgain) {
      isTextAgain = await CommonDialog.askStartToRemainQuestionsDialog();
    }
    Get.toNamed(
      NewGrammarTestScreen.name,
      arguments: {'grammarStep': grammarStep, 'isTextAgain': isTextAgain},
    );
  }

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    for (var i = 0; i < grammarStep.grammars.length; i++) {
      final grammer = grammarStep.grammars[i];
      isSaveds[i] = MyBookController.to.isSavedInJgBook(
        MyWord.grammerToWord(grammer),
      );
    }

    isHideMeanIdxs.assignAll(
      List.generate(grammarStep.grammars.length, (_) => false),
    );
  }

  void toggleSaved(int index) {
    final grammar = grammarStep.grammars[index];
    final savedGrammar = MyWord.grammerToWord(grammar);
    if (isSaveds[index]) {
      isSaveds[index] = false;
      MyBookController.to.deleteMyWord(savedGrammar);
    } else {
      isSaveds[index] = true;
      MyBookController.to.addMyWord(savedGrammar);

      if (SettingController.to.saveWordNoti) {
        SnackBarHelper.showSelectableSuccessSnackBar(
          '${savedGrammar.word} ${AppString.savedWord.tr}\n${AppString.checkItAtJGBook.tr}',
        );
      }
    }
  }
}
