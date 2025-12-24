import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/new_my_word_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/widgets/myVoca_date_section.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/widgets/my_word_screen_bottom_sheet.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/my_word.dart';

class NewMyWordScreen extends GetView<NewMyWordController> {
  static String name = '/my-word';
  const NewMyWordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

          IconButton(
            onPressed: () => Get.bottomSheet(MyWordScreenBottomSheet()),
            icon: Icon(Icons.menu),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (controller.book.bookNum == 1) ...[
              _wordOrGrammarSelector(),
              SizedBox(height: 6),
            ],

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
                    final words = map[day] ?? const <MyWord>[];
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

  Obx _wordOrGrammarSelector() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(WordOrGrammar.values.length, (i) {
          final type = WordOrGrammar.values[i];
          final controllerType =
              controller.isSelectedWord
                  ? WordOrGrammar.word
                  : WordOrGrammar.grammar;
          final isSelected = controllerType == type;

          return InkWell(
            onTap: () => controller.toggleIsSelectedWord(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              decoration: BoxDecoration(
                border:
                    isSelected
                        ? Border(
                          bottom: BorderSide(
                            color: SettingController.to.mainColor,
                            width: 3,
                          ),
                        )
                        : null,
              ),
              child: Text(
                type.label,
                style:
                    isSelected
                        ? TextStyle(
                          color: SettingController.to.mainColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )
                        : TextStyle(fontSize: 17),
              ),
            ),
          );
        }),
      ),
    );
  }
}
