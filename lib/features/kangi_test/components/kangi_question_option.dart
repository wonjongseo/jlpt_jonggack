import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:jlpt_jonggack/features/kangi_test/controller/kangi_test_controller.dart';
import 'package:jlpt_jonggack/model/Question.dart';

class KangiQuestionOption extends StatelessWidget {
  const KangiQuestionOption({
    super.key,
    required this.question,
    required this.index,
    this.press,
    required this.isAnswered,
    required this.color,
    required this.text,
  });

  final bool isAnswered;
  final int index;
  final Question question;
  final VoidCallback? press;
  final Color color;
  final String text;
  @override
  Widget build(BuildContext context) {
    List<String> multMean = text.split(',');
    Size size = MediaQuery.of(context).size;

    final oneLineText = multMean.map((value) => value.trim()).join(', ');
    return GetBuilder<KangiTestController>(
      init: KangiTestController(),
      builder: (qnController) {
        Container optionCard(
          Color color,
          IconData Function() getTheRightIcon,
          Size size,
        ) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: size.height * 0.1,
            decoration: BoxDecoration(
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: Center(
              child: AutoSizeText(
                oneLineText,
                style: TextStyle(color: color, fontSize: 13),
                maxLines: 1,
                minFontSize: 9,
              ),
            ),
          );
        }

        IconData getTheRightIcon() {
          return color == const Color(0xFFE92E30) ? Icons.close : Icons.done;
        }

        return qnController.isWrong
            ? optionCard(color, getTheRightIcon, size)
            : InkWell(
              onTap: press,
              child: optionCard(color, getTheRightIcon, size),
            );
      },
    );
  }
}
