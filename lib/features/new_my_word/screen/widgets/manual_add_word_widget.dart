import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/my_voca/components/custom_text_form.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/edit_word_controller.dart';
import 'package:url_launcher/url_launcher.dart';

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
      child: SingleChildScrollView(
        controller: controller.scrollController,
        padding: EdgeInsets.all(8),
        child: Card(
          child: Form(
            key: controller.wordFormKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ).copyWith(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                      () => DropdownButton2(
                        underline: SizedBox(),
                        value: controller.externalDictType.value,
                        onMenuStateChange: (isOpen) {
                          controller.isDropdownButtonOpen = isOpen;
                        },
                        onChanged:
                            (value) => controller.toggleExternalDictType(value),
                        items: List.generate(ExternalDictType.values.length, (
                          index,
                        ) {
                          final type = ExternalDictType.values[index];
                          return DropdownMenuItem(
                            value: type,
                            child: InkWell(
                              onTap: () {
                                controller.onTapExternalType(type);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  type.label,
                                  style: TextStyle(
                                    color: type.color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  _wordTextForms(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _exampleTextForms(),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Obx(
                          () => Column(
                            children: List.generate(controller.examples.length, (
                              index,
                            ) {
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
                                      controller.deleteExample(index);
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
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
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
