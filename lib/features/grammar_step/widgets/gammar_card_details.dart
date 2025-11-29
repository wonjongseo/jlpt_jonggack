import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/controller/tts_controller.dart';
import 'package:jlpt_jonggack/common/widget/custom_appbar.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/size.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/grammar_step/widgets/grammar_description_card.dart';
import 'package:jlpt_jonggack/features/grammar_test/components/grammar_example_card.dart';
import 'package:jlpt_jonggack/features/grammar_test/grammar_test_screen.dart';
import 'package:jlpt_jonggack/model/grammar.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';
import 'package:jlpt_jonggack/config/colors.dart';

class GrammarCardDetails extends StatefulWidget {
  const GrammarCardDetails({
    super.key,
    required this.index,
    required this.grammars,
  });
  final int index;
  final List<Grammar> grammars;
  @override
  State<GrammarCardDetails> createState() => _GrammarCardDetailsState();
}

class _GrammarCardDetailsState extends State<GrammarCardDetails> {
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
  }

  UserController userController = Get.find<UserController>();

  TtsController ttsController = Get.find<TtsController>();
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
                  totalIndex: widget.grammars.length,
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int len = widget.grammars.length;
    return Scaffold(
      appBar: _appBar(len),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: PageView.builder(
            itemCount: len >= 4 ? len + 1 : len,
            controller: pageController,
            onPageChanged: (value) {
              ttsController.stop();
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
                        GrammarTestScreen.name,
                        arguments: {'grammar': widget.grammars},
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
              return GrammarCard(grammar: widget.grammars[index]);
            },
          ),
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

class GrammarCard extends StatefulWidget {
  const GrammarCard({super.key, required this.grammar});

  final Grammar grammar;

  @override
  State<GrammarCard> createState() => _GrammarCardState();
}

class _GrammarCardState extends State<GrammarCard> {
  bool isShowMoreExample = false;
  int maxLine = 1;
  @override
  void initState() {
    super.initState();

    maxLine = (widget.grammar.grammar.length / 18).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Responsive.height18,
            horizontal: Responsive.width16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  widget.grammar.grammar,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.japaneseFont,
                    fontSize: 30,
                  ),
                  maxLines: maxLine,
                ),
                SizedBox(height: 20),
                if (widget.grammar.means.isNotEmpty) ...[
                  GrammarDescriptionCard(
                    title: AppString.mean.tr,
                    content: widget.grammar.means,
                  ),
                ],
                if (widget.grammar.description.isNotEmpty) ...[
                  GrammarDescriptionCard(
                    title: AppString.description.tr,
                    content: widget.grammar.description,
                  ),
                ],
                if (widget.grammar.connectionWays.isNotEmpty) ...[
                  GrammarDescriptionCard(
                    title: AppString.connectionWays.tr,
                    content: widget.grammar.connectionWays,
                  ),
                ],
                const Divider(),
                SizedBox(height: 20),
                Text(
                  AppString.examples.tr,
                  style: TextStyle(
                    color: AppColors.mainBordColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(
                      isShowMoreExample ? widget.grammar.examples.length : 2,
                      (index2) {
                        return GrammarExampleCard(
                          index: index2,
                          examples: widget.grammar.examples,
                        );
                      },
                    ),
                    if (!isShowMoreExample)
                      TextButton(
                        onPressed: () {
                          isShowMoreExample = true;
                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          AppString.seeMoreExamples.tr,
                          style: TextStyle(
                            color: AppColors.mainBordColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: Responsive.height15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
