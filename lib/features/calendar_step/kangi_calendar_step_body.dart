import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/size.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/calendar_step/widgets/c_toggle_btn.dart';
import 'package:jlpt_jonggack/features/calendar_step/widgets/check_row_btn.dart';
import 'package:jlpt_jonggack/features/calendar_step/widgets/kangi_list_tile.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/kangi/controller/kangi_step_controller.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/screens/top_navigation_btn.dart';
import 'package:jlpt_jonggack/model/kangi_step.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

class KangiCalendarStepBody extends StatefulWidget {
  const KangiCalendarStepBody({super.key, required this.index});
  final int index;

  @override
  State<KangiCalendarStepBody> createState() => _KangiCalendarStepBodyState();
}

class _KangiCalendarStepBodyState extends State<KangiCalendarStepBody> {
  late String level;
  int currChapNumber = 0;
  UserController userController = Get.find<UserController>();
  late PageController pageController;
  List<GlobalKey> gKeys = [];
  late KangiStepController kangiController;
  @override
  void initState() {
    kangiController = Get.find<KangiStepController>();
    level = kangiController.level;

    kangiController.setKangiSteps('챕터${widget.index + 1}');

    gKeys = List.generate(
      kangiController.kangiSteps.length,
      (index) => GlobalKey(),
    );

    kangiController.pageController = PageController(
      initialPage: kangiController.step,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(
        gKeys[kangiController.step].currentContext!,
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInOut,
      );
    });
    super.initState();
  }

  IconButton _bottomSheet() {
    return IconButton(
      onPressed: () {
        Get.bottomSheet(
          Container(
            color: Colors.white,
            child: GetBuilder<KangiStepController>(
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
                      value: !controller.isHidenMean,
                    ),
                    const SizedBox(height: 10),
                    CToggleBtn(
                      label: AppString.hideUndoc.tr,
                      toggle: controller.toggleSeeUndoc,
                      value: !controller.isHidenUndoc,
                    ),
                    const SizedBox(height: 10),
                    CToggleBtn(
                      label: AppString.hideUndoc.tr,
                      toggle: controller.toggleSeeHundoc,
                      value: !controller.isHidenHundoc,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (kangiController.getKangiStep().kangis.length >= 4)
              BottomBtn(
                label: AppString.quiz.tr,
                onTap: kangiController.goToTest,
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
          'JLPT N$level ${CategoryEnum.kangis.id} - ${AppString.chapter.tr}${widget.index + 1}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [_bottomSheet()],
      ),
    );
  }

  SafeArea _body() {
    return SafeArea(
      child: GetBuilder<KangiStepController>(
        builder: (controller) {
          return Center(
            child: Column(
              children: [
                TopNavigationBtn(
                  stepList: controller.kangiSteps,
                  navigationKey: (index) => gKeys[index],
                  onTap: (index) {
                    kangiController.changeHeaderPageIndex(index);
                    setState(() {});
                  },
                  isCurrent: (index) => kangiController.step == index,
                  isFinished:
                      (index) => controller.kangiSteps[index].isFinished,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      color: Colors.white,
                      child: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: kangiController.pageController,
                        itemCount: controller.kangiSteps.length,
                        itemBuilder: (context, subStep) {
                          controller.setStep(subStep);
                          KangiStep kangiStep = controller.getKangiStep();
                          return SingleChildScrollView(
                            child: Column(
                              children: List.generate(kangiStep.kangis.length, (
                                index,
                              ) {
                                bool isSaved = controller.isSavedInLocal(
                                  kangiStep.kangis[index],
                                );
                                return KangiListTile(
                                  kangi: kangiStep.kangis[index],
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
