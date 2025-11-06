import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/size.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/calendar_step/widgets/c_toggle_btn.dart';
import 'package:jlpt_jonggack/features/calendar_step/widgets/check_row_btn.dart';
import 'package:jlpt_jonggack/features/calendar_step/widgets/japanese_list_tile.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/jlpt/controller/jlpt_step_controller.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/screens/top_navigation_btn.dart';
import 'package:jlpt_jonggack/model/jlpt_step.dart';

class JapaneseStepScreen extends StatefulWidget {
  static String name = '/japanese-step-screen';

  const JapaneseStepScreen({super.key, required this.index});
  final int index;
  @override
  State<JapaneseStepScreen> createState() => _JapaneseStepScreenState();
}

class _JapaneseStepScreenState extends State<JapaneseStepScreen> {
  late String level;
  List<GlobalKey> gKeys = [];
  JlptStepController jlptStepController = Get.find<JlptStepController>();

  @override
  void initState() {
    super.initState();

    level = jlptStepController.level;
    jlptStepController.setJlptSteps('챕터${widget.index + 1}');

    gKeys = List.generate(
      jlptStepController.jlptSteps.length,
      (index) => GlobalKey(),
    );

    jlptStepController.pageController = PageController(
      initialPage: jlptStepController.currChapNumber,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(
        gKeys[jlptStepController.currChapNumber].currentContext!,
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (jlptStepController.getJlptStep().words.length >= 4)
              BottomBtn(
                label: AppString.quiz.tr,
                onTap: jlptStepController.goToTest,
              ),
            const GlobalBannerAdmob(),
          ],
        ),
      ),
    );
  }

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(appBarHeight),
      child: AppBar(
        scrolledUnderElevation: 0.0,
        title: Text(
          'JLPT N$level ${CategoryEnum.japaneses.id} - ${AppString.chapter.tr}${widget.index + 1}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [_bottomSheet()],
      ),
    );
  }

  IconButton _bottomSheet() {
    return IconButton(
      onPressed: () {
        Get.bottomSheet(
          Container(
            color: Colors.white,
            child: GetBuilder<JlptStepController>(
              builder: (controller) {
                return Column(
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
                    CToggleBtn(
                      label: AppString.hideMean.tr,
                      toggle: controller.toggleSeeMean,
                      value: controller.isSeeMean,
                    ),
                    const SizedBox(height: 10),
                    CToggleBtn(
                      label: AppString.hideYomikata.tr,
                      toggle: controller.toggleSeeYomikata,
                      value: controller.isSeeYomikata,
                    ),
                    CheckRowBtn(
                      label: AppString.saveAllWords.tr,
                      value: controller.isAllSave(),
                      onChanged: (v) => controller.toggleAllSave(),
                    ),
                    const SizedBox(height: 40),
                  ],
                );
              },
            ),
          ),
        );
      },
      icon: const Icon(Icons.menu),
    );
  }

  Widget _body() {
    return SafeArea(
      child: GetBuilder<JlptStepController>(
        builder: (controller) {
          return Column(
            children: [
              TopNavigationBtn(
                stepList: controller.jlptSteps,
                navigationKey: (index) => gKeys[index],
                onTap: (index) {
                  jlptStepController.changeHeaderPageIndex(index);
                  setState(() {});
                },
                isCurrent: (index) => jlptStepController.step == index,
                isFinished: (index) => controller.jlptSteps[index].isFinished,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  color: Colors.white,
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: jlptStepController.pageController,
                    itemCount: controller.jlptSteps.length,
                    itemBuilder: (context, subStep) {
                      JlptStep jlptStep = controller.jlptSteps[controller.step];

                      return SingleChildScrollView(
                        child: Column(
                          children: List.generate(jlptStep.words.length, (
                            index,
                          ) {
                            bool isSaved = controller.isSavedInLocal(
                              jlptStep.words[index],
                            );
                            return JapaneseListTile(
                              word: jlptStep.words[index],
                              index: index,
                              isSaved: isSaved,
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
