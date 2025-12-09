import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';

import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/size.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/jlpt_test/controller/jlpt_test_controller.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class ScoreScreen extends StatefulWidget {
  static String name = '/score';
  const ScoreScreen({super.key});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  JlptTestController jlptController = Get.find<JlptTestController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(appBarHeight),
        child: AppBar(
          title: Text(
            "${AppString.score.tr} ${jlptController.scoreResult}",
            style: TextStyle(fontSize: appBarTextSize),
          ),
        ),
      ),
      body: _body(jlptController, size),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [const GlobalBannerAdmob()],
        ),
      ),
    );
  }

  Widget _body(JlptTestController qnController, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            AppString.wrongAnswer.tr,
            style: TextStyle(
              color: SettingController.to.mainBordColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              color: SettingController.to.blackOrWhite,
              child: Column(
                children: List.generate(qnController.wrongQuestions.length, (
                  index,
                ) {
                  String word = qnController.wrongWord(index);
                  String meanAndYomikata = qnController.wrongMean(index);
                  String yomikata = meanAndYomikata.split('\n')[1];
                  String mean = meanAndYomikata.split('\n')[0];

                  return InkWell(
                    onTap: () => qnController.manualSaveToMyVoca(index),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 0.3)),
                      child: ListTile(
                        minLeadingWidth: 80,
                        isThreeLine: true,
                        leading: Text(
                          word,
                          style: TextStyle(
                            fontSize: Responsive.height10 * 2,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppFonts.japaneseFont,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        title: Text(mean),
                        subtitle: Text(yomikata),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
