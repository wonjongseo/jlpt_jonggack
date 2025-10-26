import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/widget/animated_circular_progressIndicator.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/basic/hiragana/screens/hiragana_screen.dart';
import 'package:jlpt_jonggack/features/jlpt_home/screens/jlpt_home_screen.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/new_my_word_screen.dart';
import 'package:jlpt_jonggack/features/setting/screen/setting_screen.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';

import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/features/home/widgets/level_category_card.dart';
import 'package:jlpt_jonggack/features/home/widgets/study_category_and_progress.dart';
import 'package:jlpt_jonggack/features/my_voca/screens/my_voca_sceen.dart';
import 'package:jlpt_jonggack/features/my_voca/services/my_voca_controller.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key, required this.index});

  final int index;

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> bodys = const [BasicCard(), JLPTCards(), MyCards()];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (userController) {
        return bodys[widget.index];
      },
    );
  }
}

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
    _currentIndex = LocalReposotiry.getBasicOrJlptOrMyDetail(KindOfStudy.jlpt);
  }

  @override
  void dispose() {
    LocalReposotiry.putBasicOrJlptOrMyDetail(KindOfStudy.jlpt, _currentIndex);
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
            },
            scrollDirection: Axis.horizontal,
          ),
          items: List.generate(5, (index) {
            return LevelCategoryCard(
              title: 'N${index + 1}',
              onTap: () {
                Get.to(() => JlptHomeScreen(levelIndex: index));
                return;
              },
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StudyCategoryAndProgress(
                    caregory: AppString.word.tr,
                    curCnt: userController.user!.currentJlptWordScroes[index],
                    totalCnt: userController.user!.jlptWordScroes[index],
                  ),
                  StudyCategoryAndProgress(
                    caregory: AppString.kangi.tr,
                    curCnt: userController.user!.currentKangiScores[index],
                    totalCnt: userController.user!.kangiScores[index],
                  ),
                  StudyCategoryAndProgress(
                    caregory: AppString.grammar.tr,
                    curCnt: userController.user!.currentGrammarScores[index],
                    totalCnt: userController.user!.grammarScores[index],
                  ),
                ],
              ),
              foot: Text(
                'JLPT N${index + 1} ${AppString.jlptBookDescription.tr}',
                style: TextStyle(
                  fontFamily: AppFonts.gMaretFont,
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

  void onPageChanged(v) {
    _currentIndex = LocalReposotiry.putBasicOrJlptOrMyDetail(
      KindOfStudy.jlpt,
      v,
    );
    setState(() {});
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
    _currentIndex = LocalReposotiry.getBasicOrJlptOrMyDetail(KindOfStudy.my);

    bodys = [];
  }

  @override
  void dispose() {
    super.dispose();
    _currentIndex = LocalReposotiry.putBasicOrJlptOrMyDetail(
      KindOfStudy.my,
      _currentIndex,
    );
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
            _currentIndex = LocalReposotiry.putBasicOrJlptOrMyDetail(
              KindOfStudy.my,
              index,
            );
          },
          scrollDirection: Axis.horizontal,
        ),
        items: List.generate(controller.books.length + 1, (index) {
          if (controller.books.length == index) {
            return LevelCategoryCard(
              onTap: () => controller.goToEditBook(),
              title: AppString.createBook.tr,
              body: Center(
                child: Icon(Icons.add, color: AppColors.mainColor, size: 30),
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
                    style: TextStyle(color: AppColors.mainBordColor),
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
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.gMaretFont,
                ),
              ),
            ),
            foot: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                book.description,
                style: TextStyle(fontFamily: AppFonts.gMaretFont, fontSize: 15),
              ),
            ),
          );
        }),
      );
    });
  }

  void onPageChanged(v) {
    _currentIndex = LocalReposotiry.putBasicOrJlptOrMyDetail(KindOfStudy.my, v);
    setState(() {});
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
    _currentIndex = LocalReposotiry.getBasicOrJlptOrMyDetail(KindOfStudy.basic);
  }

  @override
  void dispose() {
    super.dispose();
    LocalReposotiry.putBasicOrJlptOrMyDetail(KindOfStudy.basic, _currentIndex);
  }

  void onPageChanged(v) {
    _currentIndex = LocalReposotiry.putBasicOrJlptOrMyDetail(
      KindOfStudy.basic,
      v,
    );
    setState(() {});
  }

  List<Widget> bodys = [
    LevelCategoryCard(
      onTap: () {
        LocalReposotiry.putBasicOrJlptOrMyDetail(KindOfStudy.basic, 0);
        Get.to(() => const HiraganaScreen(category: 'hiragana'));
      },
      title: AppString.hiraganaVocabulary.tr,

      foot: Text(AppString.hiraganaVocaDesc.tr, style: TextStyle(fontSize: 15)),
    ),
    LevelCategoryCard(
      onTap: () {
        LocalReposotiry.putBasicOrJlptOrMyDetail(KindOfStudy.basic, 1);
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
          _currentIndex = LocalReposotiry.putBasicOrJlptOrMyDetail(
            KindOfStudy.basic,
            index,
          );
        },
        scrollDirection: Axis.horizontal,
      ),
      items: List.generate(bodys.length, (index) {
        return bodys[index];
      }),
    );
  }
}
