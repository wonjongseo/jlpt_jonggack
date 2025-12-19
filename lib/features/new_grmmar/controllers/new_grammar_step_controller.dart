import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/features/grammar_step/widgets/gammar_card_details.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/new_grammar_test_screen.dart';
import 'package:jlpt_jonggack/model/grammar.dart';
import 'package:jlpt_jonggack/model/grammar_step.dart';

class NewGrammarStepController extends GetxController {
  final String chapter;
  final GrammarStep grammarStep;

  final isHideMeanIdxs = <bool>[].obs;
  final isSavedGrammars = <bool>[].obs;

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

  NewGrammarStepController(this.grammarStep, this.chapter);

  void goToDetailScreen(List<Grammar> grammars, int index) {
    Get.to(() => GrammarCardDetails(grammars: grammars, index: index));
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
    isHideMeanIdxs.assignAll(
      List.generate(grammarStep.grammars.length, (_) => false),
    );
  }
}
