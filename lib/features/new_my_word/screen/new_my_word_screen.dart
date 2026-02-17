import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/admob/interstitial_manager.dart';
import 'package:jlpt_jonggack/common/app_constant.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/common/widget/book_category_selector.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/common/widget/dialog/add_cateogry_dialog.dart';
import 'package:jlpt_jonggack/common/widget/dialog/appeal_update_jg_plus.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/new_my_word_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/widgets/myVoca_date_section.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/widgets/my_word_screen_bottom_sheet.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/book.dart';
import 'package:jlpt_jonggack/model/book_catgory.dart';
import 'package:jlpt_jonggack/model/my_word.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

class NewMyWordScreen extends GetView<NewMyWordController> {
  static String name = '/my-word';
  const NewMyWordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      bottomNavigationBar: _bottomNavigationBar(),
      floatingActionButton: Obx(() {
        if (!controller.isScrollUp) return const SizedBox.shrink();
        return FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: SettingController.to.realBlackOrWhite,
          foregroundColor: SettingController.to.blackOrWhite,
          onPressed: controller.scrollToTop,
          child: const Icon(Icons.arrow_upward_rounded),
        );
      }),
    );
  }

  void _onAdd(List<BookCategory> cats) {
    Get.closeCurrentSnackbar();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!UserController.to.user!.premieum) {
        if (cats.length >= AppConstant.jgMaxCategoryCnt) {
          Get.dialog(
            AppealUpdateJgPlus(label: AppString.upgradePlusForMoreCategory.tr),
          );
          return;
        }
      }
      final value = await Get.dialog(AddCatagoryDialog());
      if (value == null) return;

      MyBookController.to.addCategory(value);
    });
  }

  SafeArea _body() {
    return SafeArea(
      child: Obx(() {
        final map = controller.myWordsMap.value;

        final isLoading = controller.isLoading;
        final isEmpty = !isLoading && map.isEmpty;

        final keys = map.keys.toList()..sort((a, b) => b.compareTo(a));

        return CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            SliverAppBar(
              title: Obx(() => Text(controller.book.title)),
              actions: [
                if (controller.book.bookNum != 1)
                  IconButton(
                    onPressed: () {
                      MyBookController.to.goToEditBook(book: controller.book);
                    },
                    icon: const Icon(Icons.mode_edit_outline_outlined),
                  ),
                IconButton(
                  onPressed: () => Get.bottomSheet(MyWordScreenBottomSheet()),
                  icon: const Icon(Icons.menu),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Obx(() {
                      final book = MyBookController.to.selectedBookRx.value;
                      final cats = book?.categories ?? [];
                      final selectedCat = book?.selectedCategory;
                      final Map<BookCategory, int> wordCntPerCategory = {
                        for (final c in cats) c: 0,
                      };

                      for (MyWord word in book?.mywords ?? []) {
                        final cat = word.category ?? BookCategory.unspecified;
                        wordCntPerCategory[cat] =
                            (wordCntPerCategory[cat] ?? 0) + 1;
                      }

                      return BookCategorySelector(
                        label: AppString.category.tr,
                        cats: cats,
                        selectedCat: selectedCat,
                        wordCntPerCategory: wordCntPerCategory,
                        onChanged: (value) {
                          MyBookController.to.onChangeCategory(
                            value,
                            isMyBookScreen: true,
                          );
                        },
                        onAdd: () => _onAdd(cats),
                        onDelete:
                            (value) =>
                                MyBookController.to.deleteCategory(value),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  if (controller.book.bookNum == Book.jgBookNum) ...[
                    _wordOrGrammarSelector(),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 10)),

            if (isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator.adaptive()),
              )
            else if (isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text(AppString.noSavedWord.tr)),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
                  final day = keys[i];

                  final words = map[day] ?? const <MyWord>[];

                  return Column(
                    children: [
                      MyVocaDateSection(
                        date: day,
                        words: words,
                        onTap: (index) => controller.goToStudyScreen(i, index),
                        onScrollLeft:
                            (index) => controller.onScrollLeft(i, index),
                        onScrollRight:
                            (index) => controller.onScrollRight(i, index),
                      ),
                    ],
                  );
                }, childCount: keys.length),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),
          ],
        );
      }),
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
