import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/setting/screen/setting_screen.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class ScoreAndMessage extends StatelessWidget {
  const ScoreAndMessage({Key? key, required this.score, required this.size})
    : super(key: key);

  final double score;
  final Size size;
  @override
  Widget build(BuildContext context) {
    String message = '';

    if (score >= 100) {
      message = AppString.score100.tr;
    } else if (score >= 80) {
      // 80 ~ 99.9
      message = AppString.score80.tr;
    } else if (score >= 60) {
      // 60 ~ 79.9
      message = AppString.score60.tr;
    } else if (score >= 40) {
      // 40 ~ 59.9
      message = AppString.score40.tr;
    } else {
      // 0 ~ 39.9
      message = AppString.score20.tr;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isKo) ...[
              ZoomIn(
                child: Text(
                  score.toInt().toString(),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 60,
                    letterSpacing: 1.5,
                    fontFamily: 'ScoreStd',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              ZoomIn(
                child: Text(
                  ' 점',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                    letterSpacing: 1.5,
                    fontFamily: 'ScoreStd',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ] else ...[
              ZoomIn(
                child: Text(
                  'a score of ',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                    letterSpacing: 1.5,
                    fontFamily: 'ScoreStd',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              ZoomIn(
                child: Text(
                  score.toInt().toString(),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 60,
                    letterSpacing: 1.5,
                    fontFamily: 'ScoreStd',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            SizedBox(width: 10),
          ],
        ),
        ZoomIn(
          delay: const Duration(milliseconds: 300),
          child: Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.scaffoldBackground,
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
