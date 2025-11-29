import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';

import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/size.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/calendar_step/widgets/c_toggle_btn.dart';
import 'package:jlpt_jonggack/features/grammar_step/services/grammar_controller.dart';
import 'package:jlpt_jonggack/features/grammar_step/widgets/grammar_list_tile.dart';
import 'package:jlpt_jonggack/features/grammar_test/grammar_test_screen.dart';
import 'package:jlpt_jonggack/features/jlpt_home/screens/jlpt_home_screen.dart';

import 'package:jlpt_jonggack/user/controller/user_controller.dart';

// ignore: must_be_immutable
class GrammarCalendarStepScreen extends StatefulWidget {
  static String name = '/grammar-step';
  late CategoryEnum categoryEnum;

  GrammarCalendarStepScreen({super.key}) {
    categoryEnum = Get.arguments['categoryEnum'];
  }

  @override
  State<GrammarCalendarStepScreen> createState() =>
      _GrammarCalendarStepScreenState();
}

class _GrammarCalendarStepScreenState extends State<GrammarCalendarStepScreen> {
  late GrammarController grammarController;

  late String level;
  late String chapter;
  @override
  void initState() {
    super.initState();
    chapter = Get.arguments['chapter'];

    grammarController = Get.find<GrammarController>();
    level = grammarController.level;
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
            if (grammarController.getGrammarStep().grammars.length >= 4)
              BottomBtn(
                label: AppString.quiz.tr,
                onTap: () {
                  Get.toNamed(
                    GrammarTestScreen.name,
                    arguments: {
                      'grammar': grammarController.getGrammarStep().grammars,
                    },
                  );
                },
              ),
            const GlobalBannerAdmob(),
          ],
        ),
      ),
    );
  }

  SafeArea _body() {
    return SafeArea(
      child: GetBuilder<GrammarController>(
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                          controller.getGrammarStep().grammars.length,
                          (index) {
                            return GrammarListTile(
                              index: index,
                              grammars: controller.getGrammarStep().grammars,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(appBarHeight),
      child: AppBar(
        scrolledUnderElevation: 0.0,
        title: Text(
          'JLPT N$level ${CategoryEnum.grammars.id} - $chapter',
          style: TextStyle(fontWeight: FontWeight.bold),
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
            child: GetBuilder<GrammarController>(
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
}
