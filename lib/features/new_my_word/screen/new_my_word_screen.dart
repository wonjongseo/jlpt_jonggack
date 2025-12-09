import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/utils/show_bottom_sheet.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';

import 'package:jlpt_jonggack/features/new_my_word/controllers/new_my_word_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/widgets/date_picker_bottom_sheet.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/widgets/myVoca_date_section.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/my_word.dart';

class NewMyWordScreen extends GetView<NewMyWordController> {
  static String name = '/my-word';
  const NewMyWordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          title: Obx(() {
            return Text(controller.book.title);
          }),
          actions: [
            if (controller.book.bookNum != 1)
              IconButton(
                onPressed: () {
                  MyBookController.to.goToEditBook(book: controller.book);
                },
                icon: Icon(Icons.mode_edit_outline_outlined),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ).copyWith(bottom: 12, top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      showCustomBottomSheet(
                        context: context,
                        child: const DatePickerBottomSheet(),
                      );
                    },
                    child: Obx(
                      () => Icon(
                        Icons.calendar_month,
                        size: 30,
                        color:
                            controller.isRanged
                                ? SettingController.to.mainColor
                                : null,
                      ),
                    ),
                  ),
                  _typeSelecgor(),
                ],
              ),
            ),
            if (controller.book.bookNum == 1)
              Obx(() {
                return Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => controller.toggleGrammarAnd(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 14,
                      ),

                      margin: EdgeInsets.only(top: 4, bottom: 2, right: 16),
                      decoration: BoxDecoration(
                        color: AppColors.mainBordColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 40,
                            color: Colors.black.withValues(alpha: .1),
                          ),
                        ],
                      ),
                      child: Text(
                        controller.isShowGrammar ? '일본어/한자 보기' : '문법 보기',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                );
              }),
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                final map = controller.myWordsMap.value;

                if (map.isEmpty) {
                  return Center(child: Text(AppString.noSavedWord.tr));
                }

                final keys = map.keys.toList()..sort((a, b) => b.compareTo(a));

                return ListView.separated(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: keys.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final day = keys[i];
                    var words = map[day] ?? const <MyWord>[];
                    words =
                        words
                            .where(
                              (w) => w.isGrammar == controller.isShowGrammar,
                            )
                            .toList();
                    return MyVocaDateSection(
                      date: day,
                      words: words,
                      onTap: (index) {
                        controller.goToStudyScreen(i, index);
                      },
                      onScrollLeft: (index) {
                        controller.onScrollLeft(i, index);
                      },
                      onScrollRight: (index) {
                        controller.onScrollRight(i, index);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  SafeArea _bottomNavigationBar() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (controller.book.bookNum != 1) ...[
                  Expanded(
                    child: BottomBtn(
                      label: AppString.addWord.tr,
                      onTap: () {
                        controller.goToAddMyWord();
                      },
                    ),
                  ),
                  SizedBox(width: 6),
                ],
                if (controller.allMyWords.isNotEmpty)
                  Expanded(
                    child: BottomBtn(
                      label: AppString.quiz.tr,
                      onTap: () {
                        controller.goToQuiz();
                      },
                    ),
                  ),
              ],
            ),
          ),
          const GlobalBannerAdmob(),
        ],
      ),
    );
  }

  Widget _typeSelecgor() {
    return Obx(
      () => DropdownButton2(
        value: controller.selectedType,
        buttonStyleData: ButtonStyleData(
          padding: EdgeInsets.zero,
          height: 40,
          decoration: BoxDecoration(
            color: SettingController.to.blackOrWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: SettingController.to.mainColor),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: SettingController.to.mainColor),
          ),
        ),
        underline: SizedBox(),
        onChanged: controller.changeType,
        items: List.generate(MyWordType.values.length, (index) {
          final type = MyWordType.values[index];
          return DropdownMenuItem(
            value: type,
            child: Text(type.label, style: TextStyle(fontSize: 14)),
          );
        }),
      ),
    );
  }
}
