import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/common.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/common/widget/custom_appbar.dart';
import 'package:jlpt_jonggack/common/widget/kanji_stroke_viewer.dart';
import 'package:jlpt_jonggack/config/size.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/jlpt_study/widgets/word_card.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/widgets/new_gramar_card.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/new_my_word_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/grammar.dart';
import 'package:jlpt_jonggack/model/my_word.dart';
import 'package:jlpt_jonggack/model/word.dart';

class NewMyWordStudyScreen extends StatefulWidget {
  const NewMyWordStudyScreen({super.key});

  @override
  State<NewMyWordStudyScreen> createState() => _NewMyWordStudyScreenState();
}

class _NewMyWordStudyScreenState extends State<NewMyWordStudyScreen> {
  late PageController pageController;
  int pageIndex = 0;
  final controller = Get.find<NewMyWordController>();

  @override
  void initState() {
    pageIndex = controller.selectedIndex;
    pageController = PageController(initialPage: pageIndex);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = controller.allMyWords.length;

    bool hasKangi = false;
    String japanese = '';
    if (itemCount != pageIndex) {
      japanese = controller.allMyWords[pageIndex].word.split('·')[0];
      hasKangi = japanese.characters.any((char) => isKangi(char));
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(appBarHeight),
        child: AppBar(
          title:
              itemCount == pageIndex
                  ? null
                  : CustomAppBarTitle(
                    curIndex: pageIndex + 1,
                    totalIndex: controller.allMyWords.length,
                  ),
          actions: [
            if (hasKangi && controller.isSelectedWord)
              howToRightBtn(context, japanese),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (itemCount != pageIndex && itemCount != 0)
              BottomBtn(
                label: AppString.quiz.tr,
                onTap: () => controller.goToQuiz(backCnt: 1),
              ),
            const GlobalBannerAdmob(),
          ],
        ),
      ),
      body: SafeArea(
        child: PageView.builder(
          onPageChanged: (value) {
            pageIndex = value;
            if (value < controller.allMyWords.length) {
              controller.selectedIndex = value;
            }
            setState(() {});
          },
          itemCount: itemCount + 1,
          controller: pageController,
          itemBuilder: (context, index) {
            if (itemCount == index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                child: InkWell(
                  onTap: () {
                    controller.goToQuiz(backCnt: 1);
                  },
                  child: Card(
                    child: Center(
                      child: Text(
                        AppString.goToQuiz.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan.shade600,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            final word = controller.allMyWords[index];
            return word.isGrammar
                ? GrammarCard(
                  grammar: Grammar.fromMyWord(word),
                  myWordIcon: _myWordIcon(word),
                )
                : WordCard(
                  word: Word.myWordToWord(word),
                  myWordIcon: _myWordIcon(word),
                );
          },
        ),
      ),
    );
  }

  Widget _myWordIcon(MyWord word) {
    return Padding(
      padding: EdgeInsets.only(left: 8),
      child: GetBuilder<NewMyWordController>(
        builder: (context) {
          return Row(
            children: [
              Column(
                children: [
                  Checkbox.adaptive(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    value: word.isKnown,
                    onChanged: (v) {
                      controller.updateWord(word);
                    },
                  ),
                  Text(
                    word.isKnown ? AppString.known.tr : AppString.unKnown.tr,
                    style: TextStyle(
                      fontWeight: word.isKnown ? FontWeight.bold : null,
                      color:
                          word.isKnown
                              ? SettingController.to.mainBordColor
                              : null,
                      fontSize: 12,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    iconSize: 20,
                    splashRadius: 18,
                    onPressed: () {
                      controller.deleteWordInDetailPage(
                        word,
                        currentIndex: pageIndex,
                      );
                    },
                    icon: Icon(Icons.delete),
                  ),
                  Text(
                    AppString.delete.tr,
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

enum MyWordPopupMenuButtonType { edit, delete }

class MyWordPopupMenuButton extends StatelessWidget {
  final MyWord myWord;
  final Function(MyWordPopupMenuButtonType v) onSelected;
  const MyWordPopupMenuButton({
    super.key,
    required this.myWord,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MyWordPopupMenuButtonType>(
      onSelected: onSelected,
      itemBuilder:
          (context) => [
            PopupMenuItem(
              padding: EdgeInsets.symmetric(horizontal: 4),
              value: MyWordPopupMenuButtonType.edit,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  disabledForegroundColor: SettingController.to.mainBordColor,
                ),
                onPressed: null,
                label:
                    myWord.isKnown
                        ? Text(
                          AppString.known.tr,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                        : Text(AppString.unKnown.tr),
                icon: Icon(
                  myWord.isKnown
                      ? Icons.check_box_outlined
                      : Icons.check_box_outline_blank,
                ),
              ),
            ),
            PopupMenuItem(
              padding: EdgeInsets.symmetric(horizontal: 4),
              value: MyWordPopupMenuButtonType.delete,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  disabledForegroundColor: Colors.red,
                ),
                onPressed: null,
                label: Text(AppString.delete.tr),
                icon: Icon(Icons.delete),
              ),
            ),
          ],
    );
  }
}
