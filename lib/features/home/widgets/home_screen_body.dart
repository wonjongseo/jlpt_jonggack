import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/basic/hiragana/screens/hiragana_screen.dart';
import 'package:jlpt_jonggack/features/jlpt_home/screens/jlpt_home_screen.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';

import 'package:jlpt_jonggack/features/home/widgets/level_category_card.dart';
import 'package:jlpt_jonggack/features/home/widgets/study_category_and_progress.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

class JLPTCards extends StatefulWidget {
  const JLPTCards({super.key});

  @override
  State<JLPTCards> createState() => _JLPTCardsState();
}

class _JLPTCardsState extends State<JLPTCards> {
  int _currentIndex = 0;
  CarouselSliderController carouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    _currentIndex = LocalReposotiry.getProgress(KindOfStudy.jlpt.name) ?? 0;
  }

  void putBasicOrJlptOrMyDetail(int index) {
    LocalReposotiry.setProgress(KindOfStudy.jlpt.name, index);
  }

  @override
  void dispose() {
    putBasicOrJlptOrMyDetail(_currentIndex);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (userController) {
        return CarouselSlider(
          carouselController: carouselController,
          options: CarouselOptions(
            disableCenter: true,
            viewportFraction: userController.user!.isPad ? 0.55 : 0.75,
            enableInfiniteScroll: false,
            initialPage: _currentIndex,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              _currentIndex = index;
              putBasicOrJlptOrMyDetail(index);
            },
            scrollDirection: Axis.horizontal,
          ),
          items: List.generate(5, (index) {
            return LevelCategoryCard(
              title: 'N${index + 1}',
              onTap: () => Get.to(() => JlptHomeScreen(levelIndex: index)),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StudyCategoryAndProgress(
                    caregory: AppString.word.tr,
                    totalCnt: userController.user!.jlptWordScroes[index],
                    curCnt:
                        kDebugMode
                            ? (userController.user!.jlptWordScroes[index] / 1.2)
                                .toInt()
                            : userController.user!.currentJlptWordScroes[index],
                  ),
                  StudyCategoryAndProgress(
                    caregory: AppString.kangi.tr,
                    totalCnt: userController.user!.kangiScores[index],
                    curCnt:
                        kDebugMode
                            ? (userController.user!.kangiScores[index] / 2)
                                .toInt()
                            : userController.user!.currentKangiScores[index],
                  ),
                  StudyCategoryAndProgress(
                    caregory: AppString.grammar.tr,
                    totalCnt: userController.user!.grammarScores[index],
                    curCnt:
                        kDebugMode
                            ? (userController.user!.grammarScores[index] / 1.5)
                                .toInt()
                            : userController.user!.currentGrammarScores[index],
                  ),
                ],
              ),
              foot: Text(
                'JLPT N${index + 1} ${AppString.jlptBookDescription.tr}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  // fontSize: 16,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class MyCards extends StatefulWidget {
  const MyCards({super.key});

  @override
  State<MyCards> createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  CarouselSliderController carouselController = CarouselSliderController();
  int _currentIndex = 0;
  final controller = Get.find<MyBookController>();
  @override
  void initState() {
    super.initState();
    _currentIndex = LocalReposotiry.getProgress(KindOfStudy.my.name) ?? 0;

    bodys = [];
  }

  void putBasicOrJlptOrMyDetail(int index) {
    LocalReposotiry.setProgress(KindOfStudy.my.name, index);
  }

  @override
  void dispose() {
    putBasicOrJlptOrMyDetail(_currentIndex);
    super.dispose();
  }

  List<Widget> bodys = [];
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CarouselSlider(
        carouselController: carouselController,
        options: CarouselOptions(
          disableCenter: true,
          viewportFraction: UserController.to.user!.isPad ? 0.55 : 0.75,
          enableInfiniteScroll: false,
          initialPage: _currentIndex,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            _currentIndex = index;
            putBasicOrJlptOrMyDetail(index);
          },
          scrollDirection: Axis.horizontal,
        ),
        items: List.generate(controller.books.length + 1, (index) {
          if (controller.books.length == index) {
            return LevelCategoryCard(
              onTap: () => controller.goToEditBook(),
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

          final book = controller.books[index];
          return LevelCategoryCard(
            onTap: () {
              controller.tapBook(book);
            },
            title: book.title,

            extraInfo: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '${AppString.savedWordsCnt.tr}: '),
                  TextSpan(
                    text: book.mywords.length.toString(),
                    style: TextStyle(color: SettingController.to.mainBordColor),
                  ),
                  TextSpan(
                    text:
                        isKo
                            ? '개'
                            : book.mywords.length > 1
                            ? 's'
                            : '',
                  ),
                ],
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            foot: Align(
              alignment: Alignment.centerLeft,
              child: Text(book.description, style: TextStyle(fontSize: 15)),
            ),
          );
        }),
      );
    });
  }
}

class BasicCard extends StatefulWidget {
  const BasicCard({super.key});

  @override
  State<BasicCard> createState() => _BasicCardState();
}

class _BasicCardState extends State<BasicCard> {
  CarouselSliderController carouselController = CarouselSliderController();
  int _currentIndex = 0;
  UserController userController = Get.find<UserController>();
  @override
  void initState() {
    super.initState();
    _currentIndex = LocalReposotiry.getProgress(KindOfStudy.basic.name) ?? 0;
  }

  void putBasicOrJlptOrMyDetail(int inedx) {
    LocalReposotiry.setProgress(KindOfStudy.basic.name, inedx);
  }

  @override
  void dispose() {
    putBasicOrJlptOrMyDetail(_currentIndex);
    super.dispose();
  }

  List<Widget> bodys = [
    LevelCategoryCard(
      onTap: () {
        Get.to(() => const HiraganaScreen(category: 'hiragana'));
      },
      title: AppString.hiraganaVocabulary.tr,

      foot: Text(AppString.hiraganaVocaDesc.tr, style: TextStyle(fontSize: 15)),
    ),
    LevelCategoryCard(
      onTap: () {
        Get.to(() => const HiraganaScreen(category: 'katakana'));
      },
      title: AppString.katakanaVocabulary.tr,

      foot: Text(AppString.katakanaVocaDesc.tr, style: TextStyle(fontSize: 15)),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: carouselController,
      options: CarouselOptions(
        disableCenter: true,
        viewportFraction: userController.user!.isPad ? 0.55 : 0.75,
        enableInfiniteScroll: false,
        initialPage: _currentIndex,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          _currentIndex = index;
          putBasicOrJlptOrMyDetail(index);
        },
        scrollDirection: Axis.horizontal,
      ),
      items: List.generate(bodys.length, (index) {
        return bodys[index];
      }),
    );
  }
}
