import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/controller/tts_controller.dart';
import 'package:jlpt_jonggack/common/widget/custom_appbar.dart';
import 'package:jlpt_jonggack/common/widget/like_icon.dart';
import 'package:jlpt_jonggack/config/size.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/new_grmmar/controllers/new_grammar_step_controller.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/new_grammar_test_screen.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/widgets/new_gramar_card.dart';

import 'package:jlpt_jonggack/model/grammar_step.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

class GrammarCardDetails extends StatefulWidget {
  const GrammarCardDetails({
    super.key,
    required this.index,
    required this.grammerStep,
  });
  final int index;
  final GrammarStep grammerStep;
  @override
  State<GrammarCardDetails> createState() => _GrammarCardDetailsState();
}

class _GrammarCardDetailsState extends State<GrammarCardDetails> {
  final controller = Get.find<NewGrammarStepController>();

  late PageController pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    _currentPageIndex = widget.index;
    pageController = PageController(initialPage: _currentPageIndex);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    TtsController.to.stop();
  }

  UserController userController = Get.find<UserController>();

  bool isShowMoreExample = false;

  PreferredSize _appBar(int len) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(appBarHeight),
      child: AppBar(
        title:
            len == _currentPageIndex
                ? null
                : CustomAppBarTitle(
                  curIndex: _currentPageIndex + 1,
                  totalIndex: widget.grammerStep.grammars.length,
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int len = widget.grammerStep.grammars.length;
    return Scaffold(
      appBar: _appBar(len),
      body: SafeArea(
        child: PageView.builder(
          itemCount: len >= 4 ? len + 1 : len,
          controller: pageController,
          onPageChanged: (value) {
            TtsController.to.stop();
            isShowMoreExample = false;
            setState(() {});
            _currentPageIndex = value;
            setState(() {});
          },
          itemBuilder: (context, index) {
            if (index == len) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 16,
                ),
                child: InkWell(
                  onTap: () {
                    Get.offAndToNamed(
                      NewGrammarTestScreen.name,
                      arguments: {'grammerStep': widget.grammerStep},
                    );
                  },
                  child: Card(
                    child: Center(
                      child: Text(
                        AppString.goToQuiz.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan.shade600,
                          fontSize: 20.4,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            return Obx(
              () => GrammarCard(
                grammar: widget.grammerStep.grammars[index],
                myWordIcon: LikeIcon(
                  isSaved: controller.isSaveds[index],
                  onTap: () {
                    controller.toggleSaved(index);
                  },
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [const GlobalBannerAdmob()],
        ),
      ),
    );
  }
}
