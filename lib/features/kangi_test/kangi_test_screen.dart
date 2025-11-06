import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/kangi_test/controller/kangi_test_controller.dart';
import 'package:jlpt_jonggack/features/kangi_test/components/kangi_test_card.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/widgets/progress_bar.dart';

import '../../config/colors.dart';

const KANGI_TEST = 'kangi';
const CONTINUTE_KANGI_TEST = 'continue_kangi_test';

class KangiTestScreen extends StatelessWidget {
  static String name = '/kangi_test';
  const KangiTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    KangiTestController kangiTestController = Get.put(KangiTestController());

    kangiTestController.init(Get.arguments);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(kangiTestController),
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
    return GetBuilder<KangiTestController>(
      builder: (kangiQuestionController) {
        return IgnorePointer(
          ignoring: kangiQuestionController.isDisTouchable,
          child: SafeArea(
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
                              text:
                                  '${kangiQuestionController.questionNumber.value}',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineMedium!.copyWith(
                                fontFamily: AppFonts.japaneseFont,
                                color: AppColors.mainBordColor,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "/${kangiQuestionController.questions.length}",
                              style: Theme.of(context).textTheme.headlineSmall!
                                  .copyWith(fontFamily: AppFonts.japaneseFont),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: kangiQuestionController.pageController,
                    onPageChanged: kangiQuestionController.updateTheQnNum,
                    itemCount: kangiQuestionController.questions.length,
                    itemBuilder: (context, index) {
                      return KangiQuestionCard(
                        question: kangiQuestionController.questions[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _appBar(KangiTestController kangiQuestionController) {
    return AppBar(
      title: const ProgressBar(isKangi: true),
      actions: [
        GetBuilder<KangiTestController>(
          builder: (controller) {
            return Padding(
              padding: EdgeInsets.only(right: Responsive.width15),
              child: TextButton(
                onPressed: kangiQuestionController.skipQuestion,
                child: Text(
                  controller.text,
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
