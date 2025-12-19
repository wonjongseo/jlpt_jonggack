import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/size.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/calendar_step/widgets/c_toggle_btn.dart';
import 'package:jlpt_jonggack/features/new_grmmar/controllers/new_grammar_controller.dart';
import 'package:jlpt_jonggack/features/new_grmmar/controllers/new_grammar_step_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/font_size_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/grammar.dart';

// OK
class NewGrammarStepScreen extends GetView<NewGrammarStepController> {
  static String name = '/new-grammar-step';
  const NewGrammarStepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.grammarStep.grammars.length >= 4)
              BottomBtn(
                label: AppString.quiz.tr,
                onTap: controller.goToTestScreen,
              ),
            const GlobalBannerAdmob(),
          ],
        ),
      ),
    );
  }

  SafeArea _body() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Card(
          shape: RoundedRectangleBorder(),
          margin: EdgeInsets.zero,
          child: ListView.builder(
            shrinkWrap: false,
            itemCount: controller.grammarStep.grammars.length,
            itemBuilder: (context, index) {
              final grammars = controller.grammarStep.grammars;
              return _grammarListTile(index, grammars);
            },
          ),
        ),
      ),
    );
  }

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(appBarHeight),
      child: AppBar(
        title: Text(
          'JLPT N${NewGrammarController.to.level} ${CategoryEnum.grammars.id} - ${controller.chapter}',
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
                Obx(
                  () => CToggleBtn(
                    label: AppString.hideMean.tr,
                    onChanged: controller.toggleHideMean,
                    value: controller.isHideMean,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
      icon: const Icon(Icons.menu),
    );
  }

  Widget _grammarListTile(int index, List<Grammar> grammars) {
    final grammar = grammars[index];

    return Obx(() {
      final isHideMean =
          controller.isHideMean && controller.isHideMeanIdxs[index];

      return InkWell(
        onTap: () => controller.goToDetailScreen(grammars, index),
        child: Container(
          decoration: BoxDecoration(border: Border.all(width: 0.3)),
          child: ListTile(
            isThreeLine: true,
            title: Text(
              grammar.grammar,
              style: TextStyle(
                fontSize: FSController.to.baseFS + 3,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                fontFamily: AppFonts.japaneseFont,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap:
                    isHideMean
                        ? () => controller.toggleHideMeanByIdx(index)
                        : null,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isHideMean ? Colors.grey : null,
                  ),
                  child: Text(
                    isHideMean ? '' : grammar.means,
                    style: TextStyle(
                      fontSize: FSController.to.baseFS + 2,
                      fontFamily: AppFonts.descriptionFont,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
