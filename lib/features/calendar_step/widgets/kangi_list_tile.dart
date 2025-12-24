import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/widget/like_icon.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/jlpt_and_kangi/kangi/controller/kangi_step_controller.dart';
import 'package:jlpt_jonggack/features/kangi_study/widgets/screens/kangi_study_sceen.dart';
import 'package:jlpt_jonggack/features/setting/controller/font_size_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/kangi.dart';
import 'package:jlpt_jonggack/model/my_word.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

class KangiListTile extends StatefulWidget {
  const KangiListTile({
    super.key,
    required this.kangi,
    required this.index,
    required this.isSaved,
  });
  final int index;
  final Kangi kangi;
  final bool isSaved;
  @override
  State<KangiListTile> createState() => _KangiListTileState();
}

class _KangiListTileState extends State<KangiListTile> {
  bool isWantToSeeMean = false;
  bool isWantToSeeUndoc = false;
  bool isWantToSeeHundoc = false;

  UserController userController = Get.find<UserController>();
  KangiStepController controller = Get.find<KangiStepController>();

  @override
  Widget build(BuildContext context) {
    bool isShowUndoc = isWantToSeeUndoc || !controller.isHidenUndoc;

    return InkWell(
      onTap: () => Get.to(() => KangiStudySceen(currentIndex: widget.index)),
      child: Container(
        decoration: BoxDecoration(border: Border.all(width: 0.3)),
        child: ListTile(
          dense: true,
          minLeadingWidth: 50,
          isThreeLine: true,
          subtitle: Column(
            children: [
              Row(
                children: [
                  Text(
                    '${AppString.undoc.tr}：',
                    style: TextStyle(
                      fontSize: FSController.to.baseFS,
                      fontFamily: AppFonts.japaneseFont,
                    ),
                  ),
                  SizedBox(width: 4),

                  // Expanded(
                  //   child: InkWell(
                  //     onTap:
                  //         !isShowUndoc
                  //             ? () {
                  //               isWantToSeeUndoc = true;
                  //               setState(() {});
                  //             }
                  //             : null,
                  //     child: Container(
                  //       padding: EdgeInsets.all(8),
                  //       decoration: BoxDecoration(
                  //         color: !isShowUndoc ? Colors.grey : null,
                  //       ),
                  //       child:
                  //           !isShowUndoc
                  //               ? Text('')
                  //               : Text(
                  //                 widget.kangi.undoc,
                  //                 style: TextStyle(
                  //                   fontSize: FSController.to.baseFS + 2,
                  //                   overflow: TextOverflow.ellipsis,
                  //                   fontFamily: AppFonts.japaneseFont,
                  //                 ),
                  //               ),
                  //     ),
                  //   ),
                  // ),
                  if (isWantToSeeUndoc || !controller.isHidenUndoc)
                    Flexible(
                      child: Text(
                        widget.kangi.undoc,
                        style: TextStyle(
                          fontSize: FSController.to.baseFS + 2,
                          overflow: TextOverflow.ellipsis,
                          fontFamily: AppFonts.japaneseFont,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          isWantToSeeUndoc = true;
                          setState(() {});
                        },
                        child: Container(height: 20, color: Colors.grey),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    '${AppString.hundoc.tr}：',
                    style: TextStyle(
                      fontSize: FSController.to.baseFS,
                      fontFamily: AppFonts.japaneseFont,
                    ),
                  ),
                  SizedBox(width: 4),
                  if (isWantToSeeHundoc || !controller.isHidenHundoc)
                    Flexible(
                      child: Text(
                        widget.kangi.hundoc,
                        style: TextStyle(
                          fontSize: FSController.to.baseFS + 2,
                          overflow: TextOverflow.ellipsis,
                          fontFamily: AppFonts.japaneseFont,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          isWantToSeeHundoc = true;
                          setState(() {});
                        },
                        child: Container(height: 20, color: Colors.grey),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 2),
            ],
          ),
          title: _title(),
          leading: Text(
            widget.kangi.japan,
            style: TextStyle(
              fontSize: 30,
              // color: realBlackOrWhite,
              fontFamily: AppFonts.japaneseFont,
            ),
          ),
          trailing: LikeIcon(
            isSaved: widget.isSaved,
            onTap:
                () => controller.toggleSaveWord(
                  MyWord.kangiToMyWord(widget.kangi),
                ),
          ),
        ),
      ),
    );
  }

  Padding _title() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 25,
        child:
            isWantToSeeMean || !controller.isHidenMean
                ? Text(
                  widget.kangi.mean,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.japaneseFont,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
                : InkWell(
                  onTap: () {
                    isWantToSeeMean = true;
                    setState(() {});
                  },
                  child: Container(
                    width: double.infinity,
                    height: 15,
                    color: Colors.grey,
                  ),
                ),
      ),
    );
  }
}
