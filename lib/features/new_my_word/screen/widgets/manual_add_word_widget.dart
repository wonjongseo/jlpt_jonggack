import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/interstitial_manager.dart';
import 'package:jlpt_jonggack/common/app_constant.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/common/widget/book_category_selector.dart';
import 'package:jlpt_jonggack/common/widget/custom_text_feild.dart';
import 'package:jlpt_jonggack/common/widget/dialog/add_cateogry_dialog.dart';

import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/edit_word_controller.dart';
import 'package:jlpt_jonggack/model/book_catgory.dart';

TextStyle accentTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: AppColors.mainColor,
  fontSize: 16,
);

class ManualAddWordWidget extends GetView<EditWordController> {
  const ManualAddWordWidget({super.key});

  final textFormInterval = 18.0;
  @override
  Widget build(BuildContext context) {
    final isGrammar = controller.jgWord?.isGrammar ?? false;
    final isCantDelete = isGrammar && controller.examples.length == 1;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        controller: controller.scrollController,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _naverOrGoogle(),

                _textForms(),
                SizedBox(height: textFormInterval),

                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Obx(() {
                    final examples = controller.examples;
                    return Column(
                      children: List.generate(examples.length, (index) {
                        final example = controller.examples[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${index + 1}. ${example.word}",
                                        style: const TextStyle(
                                          fontFamily: AppFonts.japaneseFont,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        example.mean,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              if (!isCantDelete)
                                TextButton(
                                  onPressed:
                                      () => controller.deleteExample(index),
                                  child: Text(
                                    AppString.delete.tr,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                    );
                  }),
                ),

                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _naverOrGoogle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
        () => DropdownButton2(
          underline: SizedBox(),
          value: controller.externalDictType.value,
          onMenuStateChange: (isOpen) {
            controller.isDropdownButtonOpen = isOpen;
          },
          onChanged: (value) => controller.toggleExternalDictType(value),
          items: List.generate(ExternalDictType.values.length, (index) {
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
    );
  }

  void _onAdd(List<BookCategory> cats) {
    Get.closeCurrentSnackbar();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (cats.length >= AppConstant.jgMaxCategoryCnt) {
        Get.dialog(
          AppealUpdateJgPlus(label: AppString.upgradePlusForMoreCategory.tr),
        );
        return;
      }
      final value = await Get.dialog(AddCatagoryDialog());
      if (value == null) return;

      MyBookController.to.addCategory(value);
    });
  }

  Widget _textForms() {
    return Column(
      children: [
        Obx(() {
          final book = MyBookController.to.selectedBookRx.value;
          final cats = book?.categories ?? [];
          final selectedCat = book?.selectedCategory;

          return BookCategorySelector(
            label: AppString.category.tr,
            cats: cats,
            selectedCat: selectedCat,
            onChanged: (value) {
              MyBookController.to.onChangeCategory(value);
            },
            onAdd: () => _onAdd(cats),
            onDelete: (value) => MyBookController.to.deleteCategory(value),
          );
        }),
        SizedBox(height: textFormInterval),
        CustomTextFormField(
          needContentPadding: true,
          textInputAction: TextInputAction.next,
          controller: controller.japaneseController,
          focusNode: controller.japaneseFocusNode,
          autofocus: controller.jgWord == null,
          label: TextInputEnum.japanese.name,
        ),
        SizedBox(height: textFormInterval),
        if (!(controller.jgWord?.isGrammar ?? false)) ...[
          CustomTextFormField(
            needContentPadding: true,
            textInputAction: TextInputAction.next,
            controller: controller.yomikataController,
            focusNode: controller.yomikataFocusNode,

            label: TextInputEnum.yomikata.name,
          ),
          SizedBox(height: textFormInterval),
        ],

        CustomTextFormField(
          needContentPadding: true,
          textInputAction: TextInputAction.done,
          controller: controller.meanController,
          focusNode: controller.meanFocusNode,

          label: TextInputEnum.mean.name,
        ),
        SizedBox(height: textFormInterval),
        if (controller.jgWord?.isGrammar ?? false) ...[
          CustomTextFormField(
            needContentPadding: true,
            textInputAction: TextInputAction.done,
            controller: controller.descriptionCtl,
            label: TextInputEnum.description.name,
          ),
          SizedBox(height: textFormInterval),
          CustomTextFormField(
            needContentPadding: true,
            textInputAction: TextInputAction.done,
            controller: controller.connectionWaysCtl,
            label: TextInputEnum.connectionWays.name,
          ),
          SizedBox(height: textFormInterval),
        ],
        _exampleTextForms(),
      ],
    );
  }

  Widget _exampleTextForms() {
    return Form(
      key: controller.exampleFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomTextFormField(
            needContentPadding: true,
            textInputAction: TextInputAction.next,
            controller: controller.exampleWordController,
            focusNode: controller.exampleWordFocusNode,
            label: TextInputEnum.exampleSentence.name,
          ),
          SizedBox(height: textFormInterval),
          CustomTextFormField(
            needContentPadding: true,
            textInputAction: TextInputAction.done,
            controller: controller.exampleMeanController,
            focusNode: controller.exampleMeanFocusNode,
            label: TextInputEnum.exampleMean.name,
          ),
        ],
      ),
    );
  }
}
