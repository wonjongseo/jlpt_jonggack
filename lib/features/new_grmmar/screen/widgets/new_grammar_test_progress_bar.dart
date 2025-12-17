import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:jlpt_jonggack/config/colors.dart';

class NewGrammarTestProgressBar extends StatelessWidget {
  const NewGrammarTestProgressBar({
    super.key,
    required this.size,
    required this.currentValue,
  });
  final Size size;
  final double currentValue;

  @override
  Widget build(BuildContext context) {
    return FAProgressBar(
      currentValue: currentValue,
      maxValue: 100,
      displayText: '%',
      size: 35,
      formatValueFixed: 0,
      backgroundColor: AppColors.darkGrey,
      progressColor: AppColors.lightGreen,
      borderRadius:
          size.width > 500
              ? BorderRadius.circular(30)
              : BorderRadius.circular(12),
      displayTextStyle: TextStyle(
        color: const Color(0xFFFFFFFF),
        fontSize: size.width > 500 ? 18 : 14,
      ),
    );
  }
}
