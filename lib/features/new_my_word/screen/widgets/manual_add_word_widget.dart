import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/my_voca/components/custom_text_form.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/edit_word_controller.dart';

TextStyle accentTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: AppColors.mainColor,
  fontSize: 16,
);

class ManualAddWordWidget extends GetView<EditWordController> {
  static String name = '/new-add-my-word';
  const ManualAddWordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: controller.scrollController,
            padding: EdgeInsets.all(8),
            child: Card(
              child: Form(
                key: controller.wordFormKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    children: [
                      SizedBox(height: 12),
                      _wordTextForms(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _exampleTextForms(),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Obx(
                              () => Column(
                                children: List.generate(
                                  controller.examples.length,
                                  (index) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            "${index + 1}. ${controller.examples![index].word}",
                                            style: const TextStyle(
                                              fontFamily: AppFonts.japaneseFont,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            controller.examples!.removeAt(
                                              index,
                                            );
                                            // setState(() {});
                                          },
                                          child: Text(
                                            "삭제",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: BottomBtn(label: '저장', onTap: addWord),
          // ),
        ],
      ),
    );
  }

  Widget _wordTextForms() {
    return Column(
      children: [
        CustomTextForm(
          textInputEnum: TextInputEnum.JAPANESE,
          textController: controller.japaneseController,
          focusNode: controller.japaneseFocusNode,
          isFocus: TextInputEnum.JAPANESE == controller.currentFocus,
          validator: (value) {
            return controller.customValidator(
              value: value,
              textInputEnum: TextInputEnum.JAPANESE,
            );
          },
        ),
        CustomTextForm(
          textInputEnum: TextInputEnum.YOMIKATA,
          textController: controller.yomikataController,
          focusNode: controller.yomikataFocusNode,
          isFocus: TextInputEnum.YOMIKATA == controller.currentFocus,
          validator: (value) {
            return controller.customValidator(
              value: value,
              textInputEnum: TextInputEnum.YOMIKATA,
            );
          },
        ),
        CustomTextForm(
          textInputEnum: TextInputEnum.MEAN,
          textController: controller.meanController,
          focusNode: controller.meanFocusNode,
          isFocus: TextInputEnum.MEAN == controller.currentFocus,
          validator: (value) {
            return controller.customValidator(
              value: value,
              textInputEnum: TextInputEnum.MEAN,
            );
          },
        ),
      ],
    );
  }

  Widget _exampleTextForms() {
    return Form(
      key: controller.exampleFormKey,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomTextForm(
            textInputEnum: TextInputEnum.EXAMPLE_JAPANESE,
            textController: controller.exampleWordController,
            focusNode: controller.exampleWordFocusNode,
            isFocus: TextInputEnum.EXAMPLE_JAPANESE == controller.currentFocus,
            validator: (value) {
              return controller.customValidator(
                value: value,
                textInputEnum: TextInputEnum.EXAMPLE_JAPANESE,
              );
            },
          ),
          CustomTextForm(
            textInputEnum: TextInputEnum.EXAMPLE_MEAN,
            textController: controller.exampleMeanController,
            focusNode: controller.exampleMeanFocusNode,
            isFocus: TextInputEnum.EXAMPLE_MEAN == controller.currentFocus,
            validator: (value) {
              return controller.customValidator(
                value: value,
                textInputEnum: TextInputEnum.EXAMPLE_MEAN,
              );
            },
            onFieldSubmitted: (v) => controller.appendExample(),
          ),
        ],
      ),
    );
  }
}
