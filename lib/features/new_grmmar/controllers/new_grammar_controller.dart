import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/common/utils/snackbar_helper.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/grammar_step/widgets/gammar_card_details.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/new_grammar_step_screen.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/new_grammar_test_screen.dart';
import 'package:jlpt_jonggack/model/grammar.dart';
import 'package:jlpt_jonggack/model/grammar_step.dart';
import 'package:jlpt_jonggack/repository/grammar_step_repository.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

class NewGrammarStepController extends GetxController {
  final String chapter;
  final GrammarStep grammarStep;

  final isHideMeanIdxs = <bool>[].obs;

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

    print('isShowMeanIdxs : ${isHideMeanIdxs}');
  }
}

class NewGrammarController extends GetxController {
  static NewGrammarController get to => Get.find<NewGrammarController>();

  GrammarRepositroy _repositroy = GrammarRepositroy();
  final String level;
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _grammars = <GrammarStep>[].obs;
  List<GrammarStep> get grammars => _grammars.value;

  final _curIndex = 0.obs;
  int get curIndex => _curIndex.value;

  NewGrammarController(this.level);

  final carouselController = CarouselSliderController();

  @override
  void onInit() {
    _getProgress();
    getDatas();
    super.onInit();
  }

  _getProgress() {
    _curIndex.value = LocalReposotiry.getProgress(
      '${CategoryEnum.grammars.name}-$level',
    );
  }

  Future<void> getDatas() async {
    try {
      _isLoading.value = true;
      _grammars.assignAll(_repositroy.getGrammarStepByLevel(level));
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('$e');
    } finally {
      _isLoading.value = false;
    }
  }

  void onPageChanged(int index) {
    _curIndex.value = index;
  }

  bool isAllAccessable(int index) {
    return !(level == '1' && index > 2) ||
        UserController.to.user!.isPremieum ||
        UserController.to.user!.isTrik;
  }

  void onCardLongPress(int index) {
    bool accessable = isAllAccessable(index);
    if (!accessable) {
      UserController.to.changeUserAuth();
    }
  }

  void onCardTap(int index) {
    bool accessable = isAllAccessable(index);
    if (!accessable) {
      CommonDialog.appealDownLoadThePaidVersion();
      return;
    }
    _curIndex.value = index;
    carouselController.animateToPage(_curIndex.value);
    _setProgress();

    Get.toNamed(
      NewGrammarStepScreen.name,
      arguments: {
        'grammars': _grammars[index],
        'chapter': '${AppString.chapter.tr}${index + 1}',
      },
    );
  }

  void _setProgress() {
    LocalReposotiry.setProgress(
      '${CategoryEnum.grammars.name}-$level',
      _curIndex.value,
    );
  }
}
