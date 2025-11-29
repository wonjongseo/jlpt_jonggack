import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/common/widget/random_quiz_not_score_text.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/grammar_test/controller/grammar_test_controller.dart';
import 'package:jlpt_jonggack/features/grammar_test/components/grammar_test_card.dart';
import 'package:jlpt_jonggack/features/grammar_step/widgets/score_and_message.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

import '../../common/admob/banner_ad/global_banner_admob.dart';

// ignore: must_be_immutable
class GrammarTestScreen extends StatelessWidget {
  static String name = '/grammar_test';
  late GrammarTestController controller;
  GrammarTestScreen({super.key}) {
    controller = Get.put(GrammarTestController());

    controller.init(Get.arguments);
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
        double score = controller.getScore();
        return Card(
          margin: EdgeInsets.only(top: 10, left: 15, right: 15),
          color: AppColors.whiteGrey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(2),
            controller: controller.scrollController,
            child: Padding(
              padding: EdgeInsets.all(Responsive.height16),
              child: Column(
                children: [
                  if (controller.isSubmitted)
                    ScoreAndMessage(score: score, size: size)
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
                    children: List.generate(controller.questions.length, (idx) {
                      return GrammarTestCard(
                        size: size,
                        questionIndex: idx,
                        question: controller.questions[idx],
                        onChanged: (int selectedAnswerIndex) {
                          controller.clickButton(idx, selectedAnswerIndex);
                        },
                        isCorrect: !controller.wrongQIndList.contains(idx),
                        isSubmitted: controller.isSubmitted,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
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
          if (controller.isSubmitted || controller.isRandom) {
            return Get.back();
          }
          final result = await CommonDialog.beforeExitTestPageDialog();

          if (result) {
            Get.back();
            return;
          }
        },
      ),
      title: GetBuilder<GrammarTestController>(
        builder: (controller) {
          double currentProgressValue = controller.getCurrentProgressValue();
          return _AppBarProgressBar(
            size: size,
            currentValue: currentProgressValue,
          );
        },
      ),
      actions: [
        GetBuilder<GrammarTestController>(
          builder: (controller) {
            if (controller.isSubmitted) {
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
                  onTap: () => controller.againTest(),
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
                  controller.submit(controller.getScore());
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

class _AppBarProgressBar extends StatelessWidget {
  const _AppBarProgressBar({
    super.key,
    required this.currentValue,
    required this.size,
  });
  final Size size;
  final double currentValue;

  @override
  Widget build(BuildContext context) {
    return FAProgressBar(
      currentValue: currentValue,
      maxValue: 100,
      displayText: '%',
      size: Responsive.height10 * 3.5,
      formatValueFixed: 0,
      backgroundColor: AppColors.darkGrey,
      progressColor: AppColors.lightGreen,
      borderRadius:
          size.width > 500
              ? BorderRadius.circular(30)
              : BorderRadius.circular(12),
      displayTextStyle: TextStyle(
        color: const Color(0xFFFFFFFF),
        fontSize: size.width > 500 ? 18 : 14,
      ),
    );
  }
}
