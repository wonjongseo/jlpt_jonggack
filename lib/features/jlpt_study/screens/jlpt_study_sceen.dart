import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/common.dart';
import 'package:jlpt_jonggack/common/controller/tts_controller.dart';
import 'package:jlpt_jonggack/common/widget/custom_appbar.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/common/widget/kanji_stroke_viewer.dart';
import 'package:jlpt_jonggack/config/size.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/jlpt/controller/jlpt_step_controller.dart';

import 'package:jlpt_jonggack/features/jlpt_study/widgets/word_card.dart';

import 'package:jlpt_jonggack/repository/kangis_step_repository.dart';

// ignore: must_be_immutable
class JlptStudyScreen extends StatefulWidget {
  static String name = '/jlpt_study';
  const JlptStudyScreen({super.key, required this.currentIndex});
  final int currentIndex;
  @override
  State<JlptStudyScreen> createState() => _JlptStudyScreenState();
}

class _JlptStudyScreenState extends State<JlptStudyScreen> {
  final JlptStepController wordController = Get.find<JlptStepController>();
  late int currentIndex;

  KangiStepRepositroy kangiStepRepositroy = KangiStepRepositroy();

  late PageController pageController;
  @override
  void initState() {
    wordController.currentIndex = widget.currentIndex;
    currentIndex = widget.currentIndex;
    super.initState();
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    TtsController.to.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<JlptStepController>(
      builder: (controller) {
        return Scaffold(
          appBar: _appBar(controller, size),
          body: _body(context, controller),
          bottomNavigationBar: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [const GlobalBannerAdmob()],
            ),
          ),
        );
      },
    );
  }

  PreferredSize _appBar(JlptStepController controller, Size size) {
    int wordsLen = controller.getJlptStep().words.length;

    bool hasKangi = false;
    String japanese = '';
    if (wordsLen != controller.currentIndex) {
      japanese =
          controller.getJlptStep().words[controller.currentIndex].word.split(
            '·',
          )[0];
      hasKangi = japanese.characters.any((char) => isKangi(char));
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(appBarHeight),
      child: AppBar(
        title:
            wordsLen != controller.currentIndex
                ? CustomAppBarTitle(
                  curIndex: controller.currentIndex + 1,
                  totalIndex: wordsLen,
                )
                : null,
        actions: [if (hasKangi) howToRightBtn(context, japanese)],
      ),
    );
  }

  Widget _body(BuildContext context, JlptStepController controller) {
    int wordsLen = controller.getJlptStep().words.length;
    return PageView.builder(
      controller: pageController,
      onPageChanged: (value) async {
        await TtsController.to.stop();
        controller.onPageChanged(value);
      },
      itemCount: wordsLen >= 4 ? wordsLen + 1 : wordsLen,
      itemBuilder: (context, index) {
        if (index == wordsLen) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: InkWell(
              onTap: () => controller.goToTest(isOffAndToName: true),
              child: Card(
                child: Center(
                  child: Text(
                    AppString.goToQuiz.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan.shade600,
                      fontSize: Responsive.height10 * 3,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return WordCard(
          word: controller.getJlptStep().words[index],
          controller: controller,
        );
      },
    );
  }
}
