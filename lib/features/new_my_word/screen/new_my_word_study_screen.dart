import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/common/widget/custom_appbar.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/size.dart';
import 'package:jlpt_jonggack/features/jlpt_study/widgets/word_card.dart';
import 'package:jlpt_jonggack/features/my_voca/services/my_voca_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/new_my_word_controller.dart';
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
  Widget build(BuildContext context) {
    int itemCount = controller.allMyWords.length;

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
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (itemCount != pageIndex && itemCount != 0)
              BottomBtn(
                label: "퀴즈!",
                onTap: () => controller.goToQuiz(backCnt: 1),
              ),
            const GlobalBannerAdmob(),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: PageView.builder(
            onPageChanged: (value) {
              pageIndex = value;
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
                          '퀴즈 풀러 가기!',
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
              return WordCard(
                word: Word.myWordToWord(word),
                myWordIcon: _myWordIcon(word),
              );
            },
          ),
        ),
      ),
    );
  }

  Padding _myWordIcon(MyWord word) {
    return Padding(
      padding: EdgeInsets.only(left: 8),
      child: GetBuilder<NewMyWordController>(
        builder: (context) {
          return Row(
            children: [
              Column(
                children: [
                  Checkbox.adaptive(
                    value: word.isKnown,
                    onChanged: (v) {
                      controller.updateWord(word.word, !word.isKnown);
                    },
                  ),
                  if (word.isKnown)
                    Text(
                      '암기',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainBordColor,
                      ),
                    )
                  else
                    Text('미암기'),
                ],
              ),
              SizedBox(width: 12),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.deleteWordInDetailPage(
                        word,
                        isYokumatiageruWord: !controller.isManualSavedWordPage,
                      );
                    },
                    icon: Icon(Icons.delete),
                  ),
                  Text(
                    '삭제',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
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
