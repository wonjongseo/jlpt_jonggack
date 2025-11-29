import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/core/app_string.dart';

class RandomQuizNotScoreText extends StatelessWidget {
  const RandomQuizNotScoreText({
    super.key,
    required this.isRandom,
    this.isGrammar = false,
  });
  final bool isRandom;
  final bool isGrammar;
  @override
  Widget build(BuildContext context) {
    return isRandom
        ? Padding(
          padding:
              isGrammar
                  ? EdgeInsets.only(top: 8, left: 4, bottom: 16)
                  : EdgeInsets.only(top: 5, left: 32, bottom: 20),
          child: Row(
            children: [
              Text(
                AppString.randomQuizArntScored.tr,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        )
        : SizedBox(height: isGrammar ? 16 : 20);
  }
}
