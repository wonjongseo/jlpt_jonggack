import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';

import 'package:jlpt_jonggack/common/controller/tts_controller.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/screens/japanese_book_step_body.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/screens/kangi_book_step_body.dart';
import 'package:jlpt_jonggack/features/new_grmmar/controllers/new_grammar_controller.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/widgets/new_grammar_book_step_body.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/features/search/widgets/search_widget.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';
import 'package:jlpt_jonggack/services/random_test_generator.dart';

class JlptHomeScreen extends StatefulWidget {
  static String name = '/jlpt_book';

  const JlptHomeScreen({super.key, required this.levelIndex});
  final int levelIndex;
  @override
  State<JlptHomeScreen> createState() => _JlptHomeScreenState();
}

class _JlptHomeScreenState extends State<JlptHomeScreen> {
  late PageController pageController;
  TtsController ttsController = Get.find<TtsController>();
  String name = '';
  int categoryIndex = 0;
  onPageChanged(int newPage) {
    categoryIndex = newPage;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    categoryIndex = LocalReposotiry.getProgress('${widget.levelIndex + 1}');
    pageController = PageController(initialPage: categoryIndex);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  Widget getBodys(CategoryEnum categoryEnum) {
    String level = (widget.levelIndex + 1).toString();

    switch (categoryEnum) {
      case CategoryEnum.japaneses:
        return JapaneseBookStepBody(level: level);
      case CategoryEnum.grammars:
        Get.put(NewGrammarController(level));
        return NewGrammarBookStepBody();
      case CategoryEnum.kangis:
        return KangiBookStepBody(level: level);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('JLPT N${widget.levelIndex + 1}')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Responsive.width20),
          child: Column(
            children: [
              NewSearchWidget(isHomeScreen: true),
              SizedBox(height: 8),
              _navigator(),
              SizedBox(height: 4),
              Flexible(
                flex: 6,
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: CategoryEnum.values.length,
                  controller: pageController,
                  onPageChanged: onPageChanged,
                  itemBuilder: (context, index) {
                    return getBodys(CategoryEnum.values[index]);
                  },
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: BottomBtn(
                fontSize: isKo ? 18 : 16,
                label:
                    'N${widget.levelIndex + 1} ${CategoryEnum.values[categoryIndex].id} ${AppString.randomQuiz.tr}',
                onTap: () {
                  RandomTestGenerator.randomText(
                    widget.levelIndex + 1,
                    CategoryEnum.values[categoryIndex],
                  );
                },
              ),
            ),
            const GlobalBannerAdmob(),
          ],
        ),
      ),
    );
  }

  Row _navigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(CategoryEnum.values.length, (index) {
        final type = CategoryEnum.values[index];
        return TextButton(
          onPressed: () {
            LocalReposotiry.setProgress('${widget.levelIndex + 1}', index);
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
          child: Container(
            padding: isEn ? EdgeInsets.only(bottom: 2) : null,
            decoration: BoxDecoration(
              border:
                  categoryIndex == index
                      ? Border(
                        bottom: BorderSide(
                          width: isEn ? 2 : 3,
                          color: Colors.cyan.shade600,
                        ),
                      )
                      : null,
            ),
            child: Text(
              isKo ? '${type.id} ${AppString.vocabulary.tr}' : type.id,
              style:
                  index == categoryIndex
                      ? TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan.shade600,
                        fontSize: Responsive.height17,
                      )
                      : TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: Responsive.height15,
                      ),
            ),
          ),
        );
      }),
    );
  }
}
