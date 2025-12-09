import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';

import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/size.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/kangi_test/controller/kangi_test_controller.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/features/setting/controller/font_size_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

const KANGI_SCORE_PATH = '/kangi_score';

class KangiScoreScreen extends StatelessWidget {
  const KangiScoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    KangiTestController kangiQuestionController =
        Get.find<KangiTestController>();

    return Scaffold(
      // appBar: _appBar(kangiQuestionController),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(appBarHeight),
        child: AppBar(
          scrolledUnderElevation: 0.0,
          title: Text(
            "${AppString.score.tr} ${kangiQuestionController.scoreResult}",
            style: TextStyle(fontSize: appBarTextSize),
          ),
        ),
      ),
      body: _body(kangiQuestionController, size),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [const GlobalBannerAdmob()],
        ),
      ),
    );
  }

  Widget _body(KangiTestController qnController, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.width16,
            vertical: Responsive.height8,
          ),
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
                  String word = qnController.wrongWord(index); //  한자
                  String meanAndYomikata = qnController.wrongMean(index);

                  String hundocAndUndoc = meanAndYomikata.split('\n')[1]; //
                  String undoc = hundocAndUndoc.split('@')[0];
                  String hundoc = hundocAndUndoc.split('@')[1];
                  String yomikata =
                      '${AppString.undoc.tr}: $undoc\n${AppString.hundoc.tr}: $hundoc';
                  String mean = meanAndYomikata.split('\n')[0]; //한자 읽는 법

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
                            fontSize: FSController.to.baseFS + 6,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppFonts.japaneseFont,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        title: Text(
                          mean,
                          style: TextStyle(fontSize: FSController.to.baseFS),
                        ),
                        subtitle: Text(
                          yomikata,
                          style: TextStyle(fontSize: FSController.to.baseFS),
                        ),
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
