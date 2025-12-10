import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/common/widget/random_quiz_not_score_text.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/jlpt_test/controller/jlpt_test_controller.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/widgets/progress_bar.dart';
import 'package:jlpt_jonggack/features/jlpt_test/widgets/jlpt_test_card.dart';
import 'package:jlpt_jonggack/features/jlpt_test/widgets/toggle_subjective_qustion_button.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

const JLPT_TEST = 'jlpt';
const IS_RANDOM = 'is_random';
const CONTINUTE_JLPT_TEST = 'continue_jlpt_test';
const MY_VOCA_TEST = 'my_vcoa_test';
const MY_VOCA_TEST_KNOWN = 'known';
const MY_VOCA_TEST_UNKNWON = 'un_known';

class JlptTestScreen extends StatelessWidget {
  static String name = '/jlpt-test';
  const JlptTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    JlptTestController jlptTestController = Get.put(JlptTestController());
    jlptTestController.init(Get.arguments);

    return Scaffold(
      appBar: _appBar(context, jlptTestController),
      body: _body(context),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [const GlobalBannerAdmob()],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return GetBuilder<JlptTestController>(
      builder: (controller) {
        return IgnorePointer(
          ignoring: controller.isDisTouchable,
          child: Stack(
            children: [
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: "問題 ",
                              style: Theme.of(context).textTheme.headlineSmall!
                                  .copyWith(fontFamily: AppFonts.japaneseFont),
                              children: [
                                TextSpan(
                                  text: '${controller.currentQuizIdx + 1}',
                                  style: theme.headlineSmall!.copyWith(
                                    fontFamily: AppFonts.japaneseFont,
                                    color: SettingController.to.mainBordColor,
                                  ),
                                ),
                                TextSpan(
                                  text: "/${controller.questions.length}",
                                  style: theme.headlineSmall!.copyWith(
                                    fontFamily: AppFonts.japaneseFont,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ToggleSubjectiveQustionButton(
                            value: SettingController.to.isSubjective,
                            onChanged: (v) {
                              JlptTestController.to.toggleSubjective();
                            },
                          ),
                        ],
                      ),
                    ),
                    RandomQuizNotScoreText(isRandom: controller.isRandom),
                    Expanded(
                      child: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: controller.pageController,
                        onPageChanged: controller.updateTheQnNum,
                        itemCount: controller.questions.length,
                        itemBuilder: (context, index) {
                          return JlptTestCard(
                            question: controller.questions[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar _appBar(BuildContext context, JlptTestController controller) {
    return AppBar(
      title: const ProgressBar(isKangi: false),
      actions: [
        GetBuilder<JlptTestController>(
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.only(right: 15),
              child: TextButton(
                onPressed: controller.skipQuestion,
                child: Text(
                  controller.nextOrSkipText,
                  style: TextStyle(
                    color: controller.color,
                    fontSize: Responsive.height20,
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
