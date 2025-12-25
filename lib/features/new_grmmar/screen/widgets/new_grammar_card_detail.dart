import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/widget/custom_appbar.dart';
import 'package:jlpt_jonggack/config/size.dart';
import 'package:jlpt_jonggack/features/new_grmmar/controllers/new_grammar_step_controller.dart';

class NewGrammarCardDetail extends StatefulWidget {
  static String name = '/NewGrammarCardDetail';

  final int index;
  const NewGrammarCardDetail({super.key, required this.index});

  @override
  State<NewGrammarCardDetail> createState() => _NewGrammarCardDetailState();
}

class _NewGrammarCardDetailState extends State<NewGrammarCardDetail> {
  int curIndex = 0;
  bool showMoreExam = false;

  final controller = Get.find<NewGrammarStepController>();
  late PageController pageController;

  @override
  void initState() {
    curIndex = widget.index;
    pageController = PageController(initialPage: curIndex);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final grammarCnt = controller.grammarStep.grammars.length;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          title:
              curIndex == grammarCnt
                  ? null
                  : CustomAppBarTitle(
                    curIndex: curIndex + 1,
                    totalIndex: grammarCnt,
                  ),
        ),
      ),
      body: SafeArea(
        child: PageView.builder(
          itemCount: grammarCnt + 1,
          onPageChanged: onPageChanged,
          itemBuilder: (context, index) {
            if (index == grammarCnt) {
              return _goToTestScreen();
            }
            return Card();
          },
        ),
      ),
    );
  }

  void onPageChanged(int value) {
    setState(() {
      curIndex = value;
      showMoreExam = false;
    });
  }

  Widget _goToTestScreen() {
    return Text('dat1a');
  }
}
