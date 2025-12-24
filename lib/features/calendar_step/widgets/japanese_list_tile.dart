import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/widget/like_icon.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/jlpt/controller/jlpt_step_controller.dart';
import 'package:jlpt_jonggack/features/jlpt_study/screens/jlpt_study_sceen.dart';
import 'package:jlpt_jonggack/features/setting/controller/font_size_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/word.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

class JapaneseListTile extends StatefulWidget {
  const JapaneseListTile({
    super.key,
    required this.isSaved,
    required this.index,
    required this.word,
  });
  final bool isSaved;
  final int index;
  final Word word;

  @override
  State<JapaneseListTile> createState() => _JapaneseListTileState();
}

class _JapaneseListTileState extends State<JapaneseListTile> {
  UserController userController = Get.find<UserController>();
  JlptStepController controller = Get.find<JlptStepController>();
  bool isWantToSeeMean = false;
  bool isWantToSeeYomikata = false;

  @override
  Widget build(BuildContext context) {
    String mean = widget.word.mean;
    String changedWord = widget.word.word;

    if (widget.word.mean.contains('1. ')) {
      mean = '${(widget.word.mean.split('\n')[0]).split('1. ')[1]}...';
    }

    if (widget.word.word.contains('·')) {
      changedWord = widget.word.word.split('·')[0];
    }

    if (changedWord.isEmpty) {
      changedWord = widget.word.yomikata;
    }

    return InkWell(
      onTap: () => Get.to(() => JlptStudyScreen(currentIndex: widget.index)),
      child: Container(
        decoration: BoxDecoration(border: Border.all(width: 0.3)),
        child: ListTile(
          isThreeLine: true,
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 30,
              child:
                  isWantToSeeYomikata || !controller.isHideYomikata
                      ? Text(
                        widget.word.yomikata,
                        style: TextStyle(
                          fontSize: FSController.to.baseFS + 2,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.descriptionFont,
                        ),
                      )
                      : InkWell(
                        onTap: () {
                          isWantToSeeYomikata = true;
                          setState(() {});
                        },
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
            ),
          ),
          title: SizedBox(
            height: 30,
            child:
                isWantToSeeMean || !controller.isHideMean
                    ? Text(
                      mean,
                      style: TextStyle(
                        fontSize: FSController.to.baseFS + 2,
                        fontFamily: AppFonts.descriptionFont,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                    : InkWell(
                      onTap: () {
                        isWantToSeeMean = true;
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.grey.shade400),
                      ),
                    ),
          ),
          leading: SizedBox(
            width: 100,
            child: AutoSizeText(
              changedWord,
              style: TextStyle(
                fontSize: FSController.to.baseFS + 6,
                fontWeight: FontWeight.w700,
                fontFamily: AppFonts.japaneseFont,
              ),
              maxLines: 1,
            ),
          ),

          trailing: LikeIcon(
            isSaved: widget.isSaved,
            onTap: () => controller.toggleSaveWord(widget.word),
          ),
        ),
      ),
    );
  }
}
