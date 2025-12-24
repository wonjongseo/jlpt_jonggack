import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/widget/custom_appbar.dart';
import 'package:jlpt_jonggack/common/widget/kanji_stroke_viewer.dart';
import 'package:jlpt_jonggack/common/widget/like_icon.dart';
import 'package:jlpt_jonggack/config/size.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/kangi/controller/kangi_step_controller.dart';
import 'package:jlpt_jonggack/features/setting/screen/setting_screen.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/my_word.dart';
import 'package:jlpt_jonggack/model/word.dart';
import 'package:jlpt_jonggack/repository/jlpt_step_repository.dart';

import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/jlpt_study/widgets/word_card.dart';

import 'package:jlpt_jonggack/model/kangi.dart';
import 'package:jlpt_jonggack/config/colors.dart';

// ignore: must_be_immutable
class KangiCard extends StatefulWidget {
  KangiCard({super.key, required this.kangi, this.controller});
  final Kangi kangi;
  KangiStepController? controller;

  @override
  State<KangiCard> createState() => _KangiCardState();
}

class _KangiCardState extends State<KangiCard> {
  List<Word> relatedVocaFromJLPTWord = [];
  @override
  initState() {
    super.initState();
    aa();
  }

  void aa() async {
    for (int i = 0; i < widget.kangi.relatedVoca.length; i++) {
      Word? word = await JlptRepositry.searchWord(
        widget.kangi.relatedVoca[i].word,
      );

      if (word == null) {
        if (isKo) {
          relatedVocaFromJLPTWord.add(widget.kangi.relatedVoca[i]);
        }
      } else {
        relatedVocaFromJLPTWord.add((word));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 11, horizontal: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.kangi.japan,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.height60,
                      fontFamily: AppFonts.japaneseFont,
                    ),
                  ),
                  if (widget.controller != null)
                    LikeIcon(
                      isSaved: widget.controller!.isSavedInLocal(widget.kangi),
                      onTap: () {
                        widget.controller!.toggleSaveWord(
                          MyWord.kangiToMyWord(widget.kangi),
                        );
                      },
                    ),
                ],
              ),
              AutoSizeText(
                widget.kangi.mean,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isKo ? 25 : 20,
                ),
                maxLines: 3,
              ),
              SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppString.undoc.tr}： ${widget.kangi.undoc}',
                          style: TextStyle(
                            fontSize: Responsive.height18,
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.japaneseFont,
                          ),
                        ),
                        Text(
                          '${AppString.hundoc.tr}：${widget.kangi.hundoc}',
                          style: TextStyle(
                            fontSize: Responsive.height18,
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.japaneseFont,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              SizedBox(height: Responsive.height10),
              Text(
                AppString.relatedWord.tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: SettingController.to.mainBordColor,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: relatedVocaFromJLPTWord.length,
                  itemBuilder: (context, index2) {
                    String mean = relatedVocaFromJLPTWord[index2].mean;
                    if (relatedVocaFromJLPTWord[index2].mean.contains(
                      '\n2. ',
                    )) {
                      mean =
                          "${relatedVocaFromJLPTWord[index2].mean.split('\n2. ')[0]}...";
                    }
                    return Container(
                      decoration: BoxDecoration(border: Border.all(width: 0.5)),
                      padding: EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        minLeadingWidth: 10 * 7,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        onTap: () async {
                          Get.to(
                            () => RelatedKangiWordScreen(
                              relatedVoca: relatedVocaFromJLPTWord,
                              index: index2,
                            ),
                            preventDuplicates: false,
                          );
                          // }
                        },
                        leading: Text(
                          relatedVocaFromJLPTWord[index2].word,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: Responsive.height20,
                            fontFamily: AppFonts.japaneseFont,
                          ),
                        ),
                        title: Text(
                          relatedVocaFromJLPTWord[index2].yomikata,
                          style: TextStyle(
                            fontSize: Responsive.height15,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppFonts.japaneseFont,
                          ),
                        ),
                        subtitle: Text(
                          mean,
                          style: TextStyle(
                            fontSize: Responsive.width14,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: Responsive.height10 * 3),
            ],
          ),
        ),
      ),
    );
  }
}

class RelatedKangiWordScreen extends StatefulWidget {
  const RelatedKangiWordScreen({
    super.key,
    required this.relatedVoca,
    required this.index,
  });

  final List<Word> relatedVoca;
  final int index;
  @override
  State<RelatedKangiWordScreen> createState() => _RelatedKangiWordScreenState();
}

class _RelatedKangiWordScreenState extends State<RelatedKangiWordScreen> {
  late PageController pageController;
  int currentPageIndex = 0;
  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.index;
    pageController = PageController(initialPage: currentPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(appBarHeight),
        child: AppBar(
          title: CustomAppBarTitle(
            curIndex: currentPageIndex + 1,
            totalIndex: widget.relatedVoca.length,
          ),
          actions: [
            howToRightBtn(context, widget.relatedVoca[currentPageIndex].word),
          ],
        ),
      ),
      body: PageView.builder(
        onPageChanged: onPageChanged,
        controller: pageController,
        itemCount: widget.relatedVoca.length,
        itemBuilder: (context, index) {
          return WordCard(word: widget.relatedVoca[index]);
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [const GlobalBannerAdmob()],
        ),
      ),
    );
  }

  void onPageChanged(value) {
    currentPageIndex = value;
    setState(() {});
  }
}
