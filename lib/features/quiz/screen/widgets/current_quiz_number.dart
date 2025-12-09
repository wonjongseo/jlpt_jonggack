import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class CurrentQuizNumber extends StatelessWidget {
  const CurrentQuizNumber({
    super.key,
    required this.currentCnt,
    required this.totalCnt,
  });

  final int currentCnt;
  final int totalCnt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Text.rich(
      TextSpan(
        text: "問題 ",
        style: Theme.of(
          context,
        ).textTheme.headlineSmall!.copyWith(fontFamily: AppFonts.japaneseFont),
        children: [
          TextSpan(
            text: '$currentCnt',
            style: theme.headlineSmall!.copyWith(
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
