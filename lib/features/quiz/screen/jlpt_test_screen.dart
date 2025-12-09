import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/common/widget/random_quiz_not_score_text.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/calendar_step/widgets/c_toggle_btn.dart';
import 'package:jlpt_jonggack/features/jlpt_test/controller/jlpt_test_controller.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/widgets/progress_bar.dart';
import 'package:jlpt_jonggack/features/jlpt_test/widgets/jlpt_test_card.dart';
import 'package:jlpt_jonggack/features/jlpt_test/widgets/toggle_subjective_qustion_button.dart';
import 'package:jlpt_jonggack/features/quiz/screen/widgets/current_quiz_number.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

const JLPT_TEST = 'jlpt';
const IS_RANDOM = 'is_random';
const CONTINUTE_JLPT_TEST = 'continue_jlpt_test';
const MY_VOCA_TEST = 'my_vcoa_test';
const MY_VOCA_TEST_KNOWN = 'known';
const MY_VOCA_TEST_UNKNWON = 'un_known';

class JlptTestScreen extends GetView<JlptTestController> {
  static String name = '/jlpt-test';
  const JlptTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
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
                          CurrentQuizNumber(
                            currentCnt: controller.questionNumber.value,
                            totalCnt: controller.questions.length,
                          ),

                          // Obx(
                          //   () => TextButton(
                          //     onPressed: controller.skipQuestion,
                          //     child: Text(
                          //       controller.nextOrSkipText,
                          //       style: TextStyle(
                          //         color: controller.color,
                          //         fontSize: Responsive.height20,
                          //       ),
                          //     ),
                          //   ),
                          // ),
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

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const ProgressBar(isKangi: false),
      actions: [
        // IconButton(
        //   onPressed: () {
        //     Get.bottomSheet(
        //       CBottomSheet(
        //         items: [
        //           Obx(
        //             () => CToggleBtn(
        //               label: AppString.openEnded.tr,
        //               value: SettingController.to.isSubjective,
        //               toggle: (v) => controller.toggleSubjective(),
        //             ),
        //           ),
        //           Obx(
        //             () => CToggleBtn(
        //               label: '오답 시 자동 저장',
        //               value: SettingController.to.isAutoSaveJapanese,
        //               toggle:
        //                   (v) =>
        //                       SettingController.to.toggleIsAuthSaveJapanese(v),
        //             ),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        //   icon: Icon(Icons.settings),
        // ),
        Obx(
          () => Padding(
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
          ),
        ),
      ],
    );
  }
}

class CBottomSheet extends StatelessWidget {
  const CBottomSheet({super.key, required this.items});

  final List<Widget> items;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: SettingController.to.blackOrWhite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            height: 5,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          ...items,
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
