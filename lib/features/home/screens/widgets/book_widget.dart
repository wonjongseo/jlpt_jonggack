import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/home/controller/book_controller.dart';

import 'package:jlpt_jonggack/features/home/widgets/level_category_card.dart';
import 'package:jlpt_jonggack/features/home/widgets/study_category_and_progress.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

class BookWidet extends GetView<BookController> {
  const BookWidet({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];

    switch (index) {
      case 0:
        items = _basic();
        break;
      case 1:
        items = _jlpt();
        break;
      case 2:
        items = _my();
        break;
    }
    return GetBuilder<UserController>(
      builder: (userController) {
        return CarouselSlider(
          options: CarouselOptions(
            disableCenter: true,
            viewportFraction: userController.user!.isPad ? 0.55 : 0.75,
            enableInfiniteScroll: false,
            initialPage: controller.curIdx,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              controller.onPageChanged(index);
            },
            scrollDirection: Axis.horizontal,
          ),
          items: items,
        );
      },
    );
  }

  List<Widget> _jlpt() {
    final user = UserController.to.user!;
    return List.generate(5, (index) {
      return LevelCategoryCard(
        title: 'N${index + 1}',
        onTap: () => controller.goToBookScreen(index),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StudyCategoryAndProgress(
              caregory: AppString.word.tr,
              totalCnt: user.jlptWordScroes[index],
              curCnt: user.currentJlptWordScroes[index],
            ),
            StudyCategoryAndProgress(
              caregory: AppString.kangi.tr,
              totalCnt: user.kangiScores[index],
              curCnt: user.currentKangiScores[index],
            ),
            StudyCategoryAndProgress(
              caregory: AppString.grammar.tr,
              totalCnt: user.grammarScores[index],
              curCnt: user.currentGrammarScores[index],
            ),
          ],
        ),
        foot: Text(
          'JLPT N${index + 1} ${AppString.jlptBookDescription.tr}',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      );
    });
  }

  List<Widget> _my() {
    final myBookCtl = Get.find<MyBookController>();
    return List.generate(myBookCtl.books.length + 1, (index) {
      if (myBookCtl.books.length == index) {
        return LevelCategoryCard(
          onTap: () => myBookCtl.goToEditBook(),
          title: AppString.createBook.tr,
          body: Center(
            child: Icon(
              Icons.add,
              color: SettingController.to.mainColor,
              size: 30,
            ),
          ),
        );
      }
      final book = myBookCtl.books[index];
      final wordCnt =
          isKo
              ? '개'
              : book.mywords.length > 1
              ? 's'
              : '';
      return LevelCategoryCard(
        // onTap: () => myBookCtl.tapBook(index),
        onTap: () => controller.goToBookScreen(index),
        title: book.title,
        extraInfo: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '${AppString.savedWordsCnt.tr}: '),
              TextSpan(
                text: book.mywords.length.toString(),
                style: TextStyle(color: SettingController.to.mainBordColor),
              ),
              TextSpan(text: wordCnt),
            ],
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        foot: Align(
          alignment: Alignment.centerLeft,
          child: Text(book.description, style: TextStyle(fontSize: 15)),
        ),
      );
    });
  }

  List<Widget> _basic() {
    return [
      LevelCategoryCard(
        onTap: () => controller.goToBookScreen(0),
        title: AppString.hiraganaVocabulary.tr,

        foot: Text(
          AppString.hiraganaVocaDesc.tr,
          style: TextStyle(fontSize: 15),
        ),
      ),
      LevelCategoryCard(
        onTap: () => controller.goToBookScreen(1),
        title: AppString.katakanaVocabulary.tr,

        foot: Text(
          AppString.katakanaVocaDesc.tr,
          style: TextStyle(fontSize: 15),
        ),
      ),
    ];
  }
}
