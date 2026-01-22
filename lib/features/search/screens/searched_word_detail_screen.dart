import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/common.dart';
import 'package:jlpt_jonggack/common/widget/custom_appbar.dart';
import 'package:jlpt_jonggack/common/widget/kanji_stroke_viewer.dart';
import 'package:jlpt_jonggack/common/widget/like_icon.dart';
import 'package:jlpt_jonggack/config/size.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/jlpt/controller/jlpt_step_controller.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/kangi/controller/kangi_step_controller.dart';
import 'package:jlpt_jonggack/features/jlpt_study/widgets/word_card.dart';
import 'package:jlpt_jonggack/features/kangi_study/widgets/kangi_card.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/widgets/new_gramar_card.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/new_add_my_word_screen.dart';
import 'package:jlpt_jonggack/model/grammar.dart';
import 'package:jlpt_jonggack/model/kangi.dart';
import 'package:jlpt_jonggack/model/my_word.dart';
import 'package:jlpt_jonggack/model/word.dart';

class SearchedWordDetailScreen extends StatefulWidget {
  const SearchedWordDetailScreen({
    super.key,
    required this.index,
    required this.searchedWords,
  });
  final int index;
  final List<Word> searchedWords;

  @override
  State<SearchedWordDetailScreen> createState() =>
      _SearchedWordDetailScreenState();
}

class _SearchedWordDetailScreenState extends State<SearchedWordDetailScreen> {
  int curIdx = 0;
  late PageController pageController;

  @override
  void initState() {
    Get.put(JlptStepController(level: 'My'));
    curIdx = widget.index;
    pageController = PageController(initialPage: curIdx);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String japanese = widget.searchedWords[curIdx].word.split('·')[0];
    bool hasKangi = japanese.characters.any((char) => isKangi(char));
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(appBarHeight),
        child: AppBar(
          title: CustomAppBarTitle(
            curIndex: curIdx + 1,
            totalIndex: widget.searchedWords.length,
          ),
          actions: [if (hasKangi) howToRightBtn(context, japanese)],
        ),
      ),
      body: SafeArea(
        child: PageView.builder(
          itemCount: widget.searchedWords.length,
          controller: pageController,
          onPageChanged: (value) {
            curIdx = value;
            setState(() {});
          },
          itemBuilder: (context, index) {
            return GetBuilder<JlptStepController>(
              builder: (jlptStepController) {
                return WordCard(
                  word: widget.searchedWords[curIdx],
                  controller: jlptStepController,
                );
              },
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

//

class SearchedKangiDetailScreen extends StatefulWidget {
  const SearchedKangiDetailScreen({
    super.key,
    required this.index,
    required this.searchedKangis,
  });
  final int index;
  final List<Kangi> searchedKangis;

  @override
  State<SearchedKangiDetailScreen> createState() =>
      _SearchedKangiDetailScreenState();
}

class _SearchedKangiDetailScreenState extends State<SearchedKangiDetailScreen> {
  int curIdx = 0;
  late PageController pageController;
  @override
  void initState() {
    Get.put(KangiStepController(level: ''));
    curIdx = widget.index;
    pageController = PageController(initialPage: curIdx);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(appBarHeight),
        child: AppBar(
          title: CustomAppBarTitle(
            curIndex: curIdx + 1,
            totalIndex: widget.searchedKangis.length,
          ),
          actions: [
            howToRightBtn(context, widget.searchedKangis[curIdx].japan),
          ],
        ),
      ),
      body: SafeArea(
        child: PageView.builder(
          itemCount: widget.searchedKangis.length,
          controller: pageController,
          onPageChanged: (value) {
            curIdx = value;
            setState(() {});
          },
          itemBuilder:
              (context, index) => GetBuilder<KangiStepController>(
                builder: (kangiStepController) {
                  return KangiCard(
                    kangi: widget.searchedKangis[curIdx],
                    controller: kangiStepController,
                  );
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

class SearchedGrammarDetailScreen extends StatefulWidget {
  const SearchedGrammarDetailScreen({
    super.key,
    required this.index,
    required this.searchedGrammar,
  });
  final int index;
  final List<Grammar> searchedGrammar;

  @override
  State<SearchedGrammarDetailScreen> createState() =>
      _SearchedGrammarDetailScreenState();
}

class _SearchedGrammarDetailScreenState
    extends State<SearchedGrammarDetailScreen> {
  int curIdx = 0;
  List<Grammar> grammars = [];
  List<bool> isSaveds = [];

  late PageController pageController;
  @override
  void initState() {
    curIdx = widget.index;
    pageController = PageController(initialPage: curIdx);

    grammars = widget.searchedGrammar;
    isSaveds = List.filled(grammars.length, false);
    for (var i = 0; i < grammars.length; i++) {
      final grammer = grammars[i];
      isSaveds[i] = MyBookController.to.isSavedInJgBook(
        MyWord.grammerToWord(grammer),
      );
    }

    super.initState();
  }

  void toggleSaved() async {
    final grammar = grammars[curIdx];
    final savedGrammar = MyWord.grammerToWord(grammar);
    if (isSaveds[curIdx]) {
      isSaveds[curIdx] = false;
      MyBookController.to.deleteMyWord(savedGrammar);
    } else {
      final isSaved = await Get.toNamed(
        NewAddMyWordScreen.name,
        arguments: savedGrammar,
      );
      if (isSaved) {
        isSaveds[curIdx] = true;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(appBarHeight),
        child: AppBar(
          title: CustomAppBarTitle(
            curIndex: curIdx + 1,
            totalIndex: grammars.length,
          ),
        ),
      ),
      body: SafeArea(
        child: PageView.builder(
          itemCount: grammars.length,
          controller: pageController,
          onPageChanged: (value) {
            curIdx = value;
            setState(() {});
          },
          itemBuilder:
              (context, index) => GrammarCard(
                grammar: widget.searchedGrammar[index],
                myWordIcon: LikeIcon(
                  isSaved: isSaveds[index],
                  onTap: () {
                    toggleSaved();
                  },
                ),
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
