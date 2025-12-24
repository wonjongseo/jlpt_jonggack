import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/widget/quiz_progress_text.dart';
import 'package:jlpt_jonggack/common/widget/random_quiz_not_score_text.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/grammar_step/widgets/score_and_message.dart';
import 'package:jlpt_jonggack/features/new_grmmar/controllers/new_grammar_test_controller.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/widgets/new_grammar_test_card.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/widgets/new_grammar_test_progress_bar.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class NewGrammarTestScreen extends GetView<NewGrammarTestController> {
  static String name = '/new-grammar_test';
  const NewGrammarTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _appBar(size),
      body: _body(),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [const GlobalBannerAdmob()],
        ),
      ),
    );
  }

  SafeArea _body() {
    return SafeArea(
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: QuizProgressText(
                currentIdx:
                    controller.quizGrammars.length -
                    controller.unansweredIdxs.length,
                totalCnt: controller.quizGrammars.length,
              ),
            ),
            Expanded(
              child: Card(
                margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                color: SettingController.to.blackOrWhite,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(18),
                  controller: controller.scrollController,
                  child: Column(
                    children: [
                      if (controller.isSubmitted)
                        ScoreAndMessage(score: controller.getScore())
                      else
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(AppString.plzSelectTheAnswer.tr),
                        ),
                      RandomQuizNotScoreText(
                        isRandom: controller.isRandom,
                        isGrammar: true,
                      ),
                      Column(
                        children: List.generate(controller.questions.length, (
                          index,
                        ) {
                          final question = controller.questions[index];

                          return NewGrammarTestCard(
                            questionIndex: index,
                            question: question,
                            onChanged:
                                (selectedIndex) => controller.clickButton(
                                  index,
                                  selectedIndex,
                                ),
                            isCorrect: !controller.wrongIdxs.contains(index),
                            isSubmitted: controller.isSubmitted,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(Size size) {
    return AppBar(
      title: Obx(() {
        return NewGrammarTestProgressBar(
          size: size,
          currentValue: controller.getCurrentProgressValue,
        );
      }),
      /**
     
       */
      actions: [
        Obx(
          () => Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: SettingController.to.mainColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 10,
                  color: Colors.black.withValues(alpha: .2),
                ),
              ],
            ),
            child: InkWell(
              onTap:
                  controller.isSubmitted
                      ? controller.againTest
                      : controller.submit,
              child: Text(
                controller.isSubmitted
                    ? AppString.again.tr
                    : AppString.submit.tr,
                style: TextStyle(
                  fontSize: isKo ? 14 : 12,
                  fontWeight: FontWeight.w600,
                  color:
                      controller.isSubmitted ? Colors.pinkAccent : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
