import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/controller/tts_controller.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/model/example.dart';

class HiraganaExampleCard extends StatelessWidget {
  const HiraganaExampleCard({super.key, required this.example});
  final Example example;
  @override
  Widget build(BuildContext context) {
    TtsController ttsController = Get.find<TtsController>();
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 0.2)),
      child: ListTile(
        onTap: () => ttsController.speak(example.word),
        leading: Text(
          '${example.word} (${example.yomikata})',
          style: TextStyle(
            fontSize: Responsive.width10 * 1.8,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: AppFonts.japaneseFont,
          ),
        ),
        minLeadingWidth: 120,
        title: FaIcon(
          FontAwesomeIcons.volumeOff,
          color: AppColors.mainBordColor,
          size: Responsive.height17,
        ),
        trailing: Text(
          example.mean,
          style: TextStyle(
            fontSize: Responsive.width10 * 1.6,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: AppFonts.japaneseFont,
          ),
        ),
      ),
    );
  }
}
