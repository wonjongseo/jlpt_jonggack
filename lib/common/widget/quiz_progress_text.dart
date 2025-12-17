import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class QuizProgressText extends StatelessWidget {
  const QuizProgressText({
    super.key,
    required this.currentIdx,
    required this.totalCnt,
  });

  final int currentIdx;
  final int totalCnt;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Text.rich(
      TextSpan(
        text: "問題 ",
        style: theme.headlineSmall!.copyWith(fontFamily: AppFonts.japaneseFont),
        children: [
          TextSpan(
            text: '$currentIdx',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontFamily: AppFonts.japaneseFont,
              color: SettingController.to.mainBordColor,
            ),
          ),
          TextSpan(
            text: "/$totalCnt",
            style: theme.headlineSmall!.copyWith(
              fontFamily: AppFonts.japaneseFont,
            ),
          ),
        ],
      ),
    );
  }
}
