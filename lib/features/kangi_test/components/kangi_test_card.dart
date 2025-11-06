import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

import '../controller/kangi_test_controller.dart';
import '../../../model/Question.dart';
import 'kangi_question_option.dart';

class KangiQuestionCard extends StatelessWidget {
  KangiQuestionCard({super.key, required this.question});

  final Question question;
  final KangiTestController controller = Get.find<KangiTestController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: AppColors.whiteGrey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Text(
            question.question.word,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: const Color(0xFF101010),
              fontSize: 30,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.japaneseFont,
            ),
          ),
          SizedBox(height: 20),
          if (controller.isSubjective) ...[
            SizedBox(height: 10),
            Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 4),
                        child: Text(
                          '한자',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      KangiTestTextInputField(
                        tec: controller.kangiTec,
                        isPressedNext: controller.isPressedNext,
                        isCorrect: controller.isAnswered1,
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 4),
                        child: Text(
                          '음독',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),

                      KangiTestTextInputField(
                        tec: controller.undocTec,
                        isPressedNext: controller.isPressedNext,
                        isCorrect: controller.isAnswered3,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 4),
                        child: Text(
                          '훈독',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      KangiTestTextInputField(
                        tec: controller.hundocTec,
                        isPressedNext: controller.isPressedNext,
                        isCorrect: controller.isAnswered3,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  BottomBtn(
                    label: '다음',
                    onTap: () {
                      controller.onNextButton(question);
                    },
                  ),
                ],
              ),
            ),
          ] else
            Row(
              children: [
                _selectKangi(),
                SizedBox(width: 10),
                _selectUndoc(),
                SizedBox(width: 10),
                _selectHundoc(),
              ],
            ),
        ],
      ),
    );
  }

  Expanded _selectHundoc() {
    return Expanded(
      child: Column(
        children: [
          Text(
            AppString.hundoc.tr,
            style: TextStyle(
              color: AppColors.scaffoldBackground,
              fontSize: Responsive.height14,
            ),
          ),
          Column(
            children: List.generate(question.options.length, (index) {
              return GetBuilder<KangiTestController>(
                builder: (controller1) {
                  Color getTheRightColor2() {
                    if (controller1.isAnswered3) {
                      if (question
                              .options[controller1.randumIndexs2[index]]
                              .yomikata
                              .split('@')[1] ==
                          controller1.correctAns3) {
                        // return const Color(0xFF6AC259);
                        return Colors.green;
                      } else if (question
                                  .options[controller1.randumIndexs2[index]]
                                  .yomikata
                                  .split('@')[1] ==
                              controller1.selectedAns3 &&
                          question
                                  .options[controller1.randumIndexs2[index]]
                                  .yomikata
                                  .split('@')[1] !=
                              controller1.correctAns3) {
                        return const Color(0xFFE92E30);
                      }
                    }
                    return AppColors.scaffoldBackground.withOpacity(0.5);
                  }

                  return KangiQuestionOption(
                    text:
                        question
                                    .options[controller1.randumIndexs2[index]]
                                    .yomikata
                                    .split('@')[1] ==
                                '-'
                            ? isEn
                                ? 'None'
                                : '없음'
                            : question
                                .options[controller1.randumIndexs2[index]]
                                .yomikata
                                .split('@')[1],
                    color: getTheRightColor2(),
                    isAnswered: controller1.isAnswered3,
                    question: question,
                    index: index,
                    press:
                        controller1.isAnswered3
                            ? () {}
                            : () => controller1.checkAns(
                              question,
                              question
                                  .options[controller1.randumIndexs2[index]]
                                  .yomikata
                                  .split('@')[1],
                              'hundoc',
                            ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Expanded _selectUndoc() {
    return Expanded(
      child: Column(
        children: [
          Text(
            AppString.undoc.tr,
            style: TextStyle(
              color: AppColors.scaffoldBackground,
              fontSize: Responsive.height14,
            ),
          ),
          Column(
            children: List.generate(question.options.length, (index) {
              return GetBuilder<KangiTestController>(
                builder: (controller1) {
                  Color getTheRightColor2() {
                    if (controller1.isAnswered2) {
                      if (question
                              .options[controller1.randumIndexs[index]]
                              .yomikata
                              .split('@')[0] ==
                          controller1.correctAns2) {
                        // return const Color(0xFF6AC259);
                        return Colors.green;
                      } else if (question
                                  .options[controller1.randumIndexs[index]]
                                  .yomikata
                                  .split('@')[0] ==
                              controller1.selectedAns2 &&
                          question
                                  .options[controller1.randumIndexs[index]]
                                  .yomikata
                                  .split('@')[0] !=
                              controller1.correctAns2) {
                        return const Color(0xFFE92E30);
                      }
                    }
                    return AppColors.scaffoldBackground.withOpacity(0.5);
                  }

                  return KangiQuestionOption(
                    text:
                        question
                                    .options[controller1.randumIndexs[index]]
                                    .yomikata
                                    .split('@')[0] ==
                                '-'
                            ? AppString.none.tr
                            : question
                                .options[controller1.randumIndexs[index]]
                                .yomikata
                                .split('@')[0],
                    color: getTheRightColor2(),
                    isAnswered: controller1.isAnswered2,
                    question: question,
                    index: index,
                    press:
                        controller1.isAnswered2
                            ? () {}
                            : () => controller1.checkAns(
                              question,
                              question
                                  .options[controller1.randumIndexs[index]]
                                  .yomikata
                                  .split('@')[0],
                              'undoc',
                            ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Expanded _selectKangi() {
    return Expanded(
      child: Column(
        children: [
          Text(isKo ? '한자' : 'Mean'),
          Column(
            children: List.generate(
              question.options.length,
              (index) => GetBuilder<KangiTestController>(
                builder: (controller1) {
                  Color getTheRightColor() {
                    if (controller1.isAnswered1) {
                      if (question.options[index].mean ==
                          controller1.correctAns) {
                        return Colors.green;
                      } else if (question.options[index].mean ==
                              controller1.selectedAns &&
                          question.options[index].mean !=
                              controller1.correctAns) {
                        return const Color(0xFFE92E30);
                      }
                    }
                    return AppColors.scaffoldBackground.withOpacity(0.5);
                  }

                  return KangiQuestionOption(
                    text: question.options[index].mean,
                    color: getTheRightColor(),
                    isAnswered: controller1.isAnswered1,
                    question: question,
                    index: index,
                    press:
                        controller1.isAnswered1
                            ? null
                            : () => controller1.checkAns(
                              question,
                              question.options[index].mean,
                              'hangul',
                            ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KangiTestTextInputField extends StatelessWidget {
  const KangiTestTextInputField({
    super.key,
    required this.tec,
    required this.isPressedNext,
    required this.isCorrect,
  });

  final TextEditingController tec;
  final bool isPressedNext;
  final bool isCorrect;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: tec,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:
                isPressedNext
                    ? isCorrect
                        ? Colors.green
                        : Color(0xFFE92E30)
                    : Colors.black,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:
                isPressedNext
                    ? isCorrect
                        ? Colors.green
                        : Color(0xFFE92E30)
                    : Colors.black,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color:
                isPressedNext
                    ? isCorrect
                        ? Colors.green
                        : Color(0xFFE92E30)
                    : Colors.black,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        errorStyle: TextStyle(fontSize: 0),
      ),
      style: const TextStyle(fontSize: 13),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '';
        }
        return null;
      },
    );
  }
}
