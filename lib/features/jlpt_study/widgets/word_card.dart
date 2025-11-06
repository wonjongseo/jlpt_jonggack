import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/controller/tts_controller.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/common/widget/kangi_text.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/grammar_test/components/grammar_example_card.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/jlpt/controller/jlpt_step_controller.dart';
import 'package:jlpt_jonggack/features/jlpt_study/widgets/related_word.dart';
import 'package:jlpt_jonggack/features/setting/screen/setting_screen.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/word.dart';
import 'package:jlpt_jonggack/repository/kangis_step_repository.dart';
import 'package:jlpt_jonggack/config/colors.dart';

// ignore: must_be_immutable
class WordCard extends StatelessWidget {
  WordCard({super.key, required this.word, this.controller, this.myWordIcon});
  JlptStepController? controller;
  final Widget? myWordIcon;
  final Word word;
  @override
  Widget build(BuildContext context) {
    List<String> temp = [];
    String japanese = word.word;
    String yomikata = word.yomikata;
    if (japanese.isEmpty) {
      japanese = yomikata;
    }
    if (yomikata.contains('@')) {
      String undoc = yomikata.split('@')[0];
      String hundoc = yomikata.split('@')[1];
      yomikata = '[$undoc / $hundoc]';
    } else {
      yomikata = '[$yomikata]';
    }

    KangiStepRepositroy kangiStepRepositroy = KangiStepRepositroy();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.width10),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 11, horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: KangiText(
                            japanese: japanese,
                            clickTwice: false,
                          ),
                        ),
                        if (controller != null)
                          IconButton(
                            onPressed: () => controller!.toggleSaveWord(word),
                            icon: FaIcon(
                              !controller!.isSavedInLocal(word)
                                  ? FontAwesomeIcons.bookmark
                                  : FontAwesomeIcons.solidBookmark,
                              color: AppColors.mainBordColor,
                              size: 22,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (myWordIcon != null)
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: myWordIcon!,
                    ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      yomikata,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: AppFonts.japaneseFont,
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  IconButton(
                    onPressed:
                        () => TtsController.to.speak(
                          word.yomikata == '-' ? word.word : word.yomikata,
                        ),
                    icon: Obx(
                      () => FaIcon(
                        TtsController.to.isPlaying
                            ? FontAwesomeIcons.volumeLow
                            : FontAwesomeIcons.volumeOff,
                        color: AppColors.mainBordColor,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                word.mean,
                style: TextStyle(
                  fontSize: isKo ? 18 : 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Divider(),
              RelatedWords(
                japanese: japanese,
                kangiStepRepositroy: kangiStepRepositroy,
                temp: temp,
              ),

              if (word.examples != null && word.examples!.isNotEmpty) ...[
                SizedBox(height: 12),
                Text(
                  AppString.examples.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.mainBordColor,
                  ),
                ),

                if (controller == null)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(word.examples!.length, (
                            index,
                          ) {
                            return GrammarExampleCard(
                              examples: word.examples!,
                              index: index,
                            );
                          }),
                        ),
                      ),
                    ),
                  )
                else ...[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!controller!.isMoreExample) ...[
                              if (word.examples!.length > 2) ...[
                                ...List.generate(2, (index) {
                                  return GrammarExampleCard(
                                    examples: word.examples!,
                                    index: index,
                                  );
                                }),
                                InkWell(
                                  onTap: controller!.onTapMoreExample,
                                  child: Text(
                                    AppString.seeMoreExamples.tr,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.mainBordColor,
                                    ),
                                  ),
                                ),
                              ] else ...[
                                ...List.generate(word.examples!.length, (
                                  index,
                                ) {
                                  return GrammarExampleCard(
                                    examples: word.examples!,
                                    index: index,
                                  );
                                }),
                              ],
                            ] else ...[
                              ...List.generate(word.examples!.length, (index) {
                                return GrammarExampleCard(
                                  examples: word.examples!,
                                  index: index,
                                );
                              }),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
