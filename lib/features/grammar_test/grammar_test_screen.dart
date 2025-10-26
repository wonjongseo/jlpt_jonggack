import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/common/widget/app_bar_progress_bar.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/grammar_test/controller/grammar_test_controller.dart';
import 'package:jlpt_jonggack/features/grammar_test/components/grammar_test_card.dart';
import 'package:jlpt_jonggack/features/grammar_step/widgets/score_and_message.dart';
import 'package:jlpt_jonggack/features/setting/screen/setting_screen.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

import '../../common/admob/banner_ad/global_banner_admob.dart';

const GRAMMAR_TEST_SCREEN = '/grammar_test';

// ignore: must_be_immutable
class GrammarTestScreen extends StatelessWidget {
  late GrammarTestController grammarTestController;
  GrammarTestScreen({super.key}) {
    grammarTestController = Get.put(GrammarTestController());

    grammarTestController.init(Get.arguments);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _appBar(size),
      body: _body(size),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [const GlobalBannerAdmob()],
        ),
      ),
    );
  }

  Widget _body(Size size) {
    return GetBuilder<GrammarTestController>(
      builder: (controller) {
        double score = grammarTestController.getScore();
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 15, right: 15),
              child: Container(
                color: AppColors.whiteGrey,
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  child: Padding(
                    padding: EdgeInsets.all(Responsive.height16),
                    child: Column(
                      children: [
                        if (controller.isSubmitted)
                          ScoreAndMessage(score: score, size: size)
                        else
                          Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(AppString.plzSelectTheAnswer.tr),
                            ),
                          ),
                        ...List.generate(controller.questions.length, (
                          questionIndex,
                        ) {
                          return GrammarTestCard(
                            size: size,
                            questionIndex: questionIndex,
                            question: controller.questions[questionIndex],
                            onChanged: (int selectedAnswerIndex) {
                              controller.clickButton(
                                questionIndex,
                                selectedAnswerIndex,
                              );
                            },
                            isCorrect:
                                !controller.wrongQIndList.contains(
                                  questionIndex,
                                ),
                            isSubmitted: controller.isSubmitted,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  AppBar _appBar(Size size) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () async {
          if (grammarTestController.isSubmitted ||
              grammarTestController.isRandom) {
            return Get.back();
          }
          bool result = await CommonDialog.beforeExitTestPageDialog();

          if (result) {
            Get.back();
            return;
          }
        },
      ),
      title: GetBuilder<GrammarTestController>(
        builder: (grammarTestController) {
          double currentProgressValue =
              grammarTestController.getCurrentProgressValue();
          return AppBarProgressBar(
            size: size,
            currentValue: currentProgressValue,
          );
        },
      ),
      actions: [
        GetBuilder<GrammarTestController>(
          builder: (grammarTestController) {
            if (grammarTestController.isSubmitted) {
              return Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
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
                  onTap: () => grammarTestController.againTest(),
                  child: Text(
                    AppString.again.tr,
                    style: TextStyle(
                      fontSize: isKo ? 14 : 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.pinkAccent,
                    ),
                  ),
                ),
              );
            }

            return Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.mainColor,
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
                onTap: () {
                  grammarTestController.submit(
                    grammarTestController.getScore(),
                  );
                },
                child: Text(
                  AppString.submit.tr,
                  style: TextStyle(
                    fontSize: isKo ? 14 : 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
