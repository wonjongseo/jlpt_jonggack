import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:jlpt_jonggack/common/app_constant.dart';

import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/common/widget/custom_text_feild.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/features/grammar_test/grammar_test_screen.dart';
import 'package:jlpt_jonggack/features/jlpt_home/screens/jlpt_home_screen.dart';
import 'package:jlpt_jonggack/features/jlpt_test/screens/jlpt_test_screen.dart';
import 'package:jlpt_jonggack/features/kangi_test/kangi_test_screen.dart';
import 'package:jlpt_jonggack/model/grammar.dart';
import 'package:jlpt_jonggack/model/grammar_step.dart';
import 'package:jlpt_jonggack/model/jlpt_step.dart';
import 'package:jlpt_jonggack/model/kangi.dart';
import 'package:jlpt_jonggack/model/kangi_step.dart';
import 'package:jlpt_jonggack/model/word.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

class RandomTestGenerator {
  static List<int> _createRandomIdx(int totalCount, int count) {
    Random random = Random();
    List<int> randomIdxs = [];
    while (randomIdxs.length < count) {
      int randomIdx = random.nextInt(totalCount);
      if (randomIdxs.contains(randomIdx)) {
        continue;
      }

      randomIdxs.add(randomIdx);
    }

    return randomIdxs;
  }

  static Future<List<Word>> _createJlptQuiz(
    int level,
    int count,
    List<Word> tempWords,
    String category,
  ) async {
    List<Word> words = [];

    List<String> categories = [];

    switch (category) {
      case '명사':
        categories.addAll(['명사', '대명사']);
        break;
      case '동사':
        categories.addAll(['동사']);
        break;
      case '형용사':
        categories.addAll(['형용사', '형용동사']);
        break;
      case '부사':
        categories.addAll(['부사']);
        break;
      case '조사':
        categories.addAll(['조사']);
        break;
      case '접속사':
        categories.addAll(['접사']);
        break;
    }
    Random random = Random();

    while (words.length < count) {
      int randomIdx = random.nextInt(tempWords.length);
      Word word = tempWords[randomIdx];

      if (words.contains(word)) {
        continue;
      }

      if (category == '랜덤' || word.category == null) {
        words.add(word);
      } else {
        String wordCategory = word.category!.split(' ')[0];

        if (categories.contains(wordCategory)) {
          words.add(word);
        } else {
          continue;
        }
      }
    }

    return words;
  }

  static Future<List<Word>> _getAllJapaneseByLevel(
    int level,
    bool isPremium,
  ) async {
    final box = Hive.box(JlptStep.boxKey);
    final keys = box.keys.where(
      (key) => (key as String).startsWith('$level-챕터'),
    );

    List<Word> tempWords = [];
    for (var key in keys) {
      Object jlptStep = box.get(key);
      if (jlptStep.runtimeType == JlptStep) {
        jlptStep = jlptStep as JlptStep;
        if (!isPremium && level == 1) {
          String sChapter = jlptStep.headTitle.split('챕터')[1];

          int chapter = int.tryParse(sChapter) ?? 100;
          if (chapter > 3) {
            continue;
          }
        }
        tempWords.addAll((jlptStep).words);
      }
    }
    return tempWords;
  }

  static Future<List<Kangi>> _createKangiQuiz(
    int level,
    int count,
    List<Kangi> tempKangis,
  ) async {
    List<Kangi> kangis = [];
    List<int> randomIdxs = _createRandomIdx(tempKangis.length, count);
    for (var randomIdx in randomIdxs) {
      kangis.add(tempKangis[randomIdx]);
    }
    return kangis;
  }

  static Future<List<Kangi>> _getAllKangisByLevel(
    int level,
    bool isPremium,
  ) async {
    final box = Hive.box(KangiStep.boxKey);
    final keys = box.keys.where(
      (key) => (key as String).startsWith('$level-챕터'),
    );

    List<Kangi> tempKangis = [];
    for (var key in keys) {
      Object jlptStep = box.get(key);
      if (jlptStep.runtimeType == KangiStep) {
        tempKangis.addAll((jlptStep as KangiStep).kangis);
      }
    }
    return tempKangis;
  }

  static Future<List<Grammar>> _getAllGrammarByLevel(
    int level,
    bool isPremium,
  ) async {
    final box = Hive.box(GrammarStep.boxKey);

    final keys = box.keys.where((key) => (key as String).startsWith('$level-'));

    List<Grammar> tempGrammars = [];
    for (var key in keys) {
      Object jlptStep = box.get(key);
      if (jlptStep.runtimeType == GrammarStep) {
        final x = key.split("-").last;
        if (int.parse(x) > 2) {
          continue;
        }
        tempGrammars.addAll((jlptStep as GrammarStep).grammars);
      }
    }
    return tempGrammars;
  }

  static Future<List<Grammar>> _createGrammarQuiz(
    int level,
    int count,
    List<Grammar> tempGrammars,
  ) async {
    List<Grammar> grammars = [];

    List<int> randomIdxs = _createRandomIdx(tempGrammars.length, count);
    for (var randomIdx in randomIdxs) {
      grammars.add(tempGrammars[randomIdx]);
    }

    return grammars;
  }

  static Future randomText(int level, CategoryEnum category) async {
    bool isPremium = false;

    if (Get.isRegistered<UserController>()) {
      isPremium =
          UserController.to.user.isPremieum || UserController.to.user.isTrik;
    }
    List<Word> tempWords = [];
    bool isHasCategory = false;
    List<Grammar> tempGrammars = [];
    List<Kangi> tempKangis = [];

    switch (category) {
      case CategoryEnum.Japaneses:
        tempWords = await _getAllJapaneseByLevel(level, isPremium);

        final tempword = tempWords.firstOrNull;

        isHasCategory =
            tempword == null
                ? false
                : tempword.category == null
                ? false
                : true;
        String? result;
        if (isHasCategory) {
          //  TODO
          // result = await Get.dialog(
          //   name: 'RandomQuizDialog',
          //   RandomQuizDialog(),
          // );
          // if (result == null) return;
        }

        List<Word> words = await _createJlptQuiz(
          level,
          AppConstant.MINIMUM_STEP_COUNT,
          tempWords,
          result ?? '랜덤',
        );

        Get.toNamed(
          JLPT_TEST_PATH,
          arguments: {JLPT_TEST: words, IS_RANDOM: true},
        );
        break;
      case CategoryEnum.Kangis:
        tempKangis = await _getAllKangisByLevel(level, isPremium);

        List<Kangi> kangis = await _createKangiQuiz(
          level,
          AppConstant.MINIMUM_STEP_COUNT,
          tempKangis,
        );
        Get.toNamed(
          KANGI_TEST_PATH,
          arguments: {KANGI_TEST: kangis, IS_RANDOM: true},
        );
        break;
      case CategoryEnum.Grammars:
        tempGrammars = await _getAllGrammarByLevel(level, isPremium);

        List<Grammar> grammars = await _createGrammarQuiz(
          level,
          AppConstant.MINIMUM_STEP_COUNT,
          tempGrammars,
        );
        Get.toNamed(
          GRAMMAR_TEST_SCREEN,
          arguments: {'grammar': grammars, IS_RANDOM: true},
        );
    }
  }

  static Future test(int level, CategoryEnum category) async {
    bool isPremium = false;
    if (Get.isRegistered<UserController>()) {
      isPremium =
          UserController.to.user.isPremieum || UserController.to.user.isTrik;
    }
    List<Word> tempWords = [];
    List<Grammar> tempGrammars = [];
    List<Kangi> tempKangis = [];
    int? maxCount;

    switch (category) {
      case CategoryEnum.Japaneses:
        tempWords = await _getAllJapaneseByLevel(level, isPremium);
        maxCount = tempWords.length;
      case CategoryEnum.Kangis:
        tempKangis = await _getAllKangisByLevel(level, isPremium);
        maxCount = tempKangis.length;
      case CategoryEnum.Grammars:
        tempGrammars = await _getAllGrammarByLevel(level, isPremium);
        maxCount = tempGrammars.length;
    }

    dynamic count = await Get.dialog(
      name: 'QuizCntForm',
      QuizCntForm(
        maxCount: maxCount,
        isJapanese: category == CategoryEnum.Japaneses,
      ),
    );
    if (count == null || count.runtimeType != String) return;

    count = int.tryParse(count) ?? 15;

    switch (category) {
      case CategoryEnum.Japaneses:
        List<Word> words = await _createJlptQuiz(level, count, tempWords, '랜덤');
        Get.toNamed(
          JLPT_TEST_PATH,
          arguments: {JLPT_TEST: words, IS_RANDOM: true},
        );
        break;
      case CategoryEnum.Kangis:
        List<Kangi> kangis = await _createKangiQuiz(level, count, tempKangis);
        Get.offAndToNamed(
          KANGI_TEST_PATH,
          arguments: {KANGI_TEST: kangis, IS_RANDOM: true},
        );
        break;
      case CategoryEnum.Grammars:
        List<Grammar> grammars = await _createGrammarQuiz(
          level,
          count,
          tempGrammars,
        );
        Get.toNamed(
          GRAMMAR_TEST_SCREEN,
          arguments: {'grammar': grammars, IS_RANDOM: true},
        );
    }
  }
}

class QuizCntForm extends StatefulWidget {
  const QuizCntForm({
    super.key,
    required this.maxCount,
    required this.isJapanese,
  });
  final int maxCount;
  final bool isJapanese;
  @override
  State<QuizCntForm> createState() => _QuizCntFormState();
}

class _QuizCntFormState extends State<QuizCntForm> {
  final TextEditingController teCtl = TextEditingController();

  int maxCount = 100;
  @override
  void initState() {
    super.initState();
    maxCount = widget.maxCount > 100 ? 100 : widget.maxCount;
  }

  String? errorMsg;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '퀴즈 갯수를 입력해주세요',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          CustomTextFormField(
            autofocus: true,
            width: size.width * .4,
            controller: teCtl,
            sufficIcon: Text('개'),
            keyboardType: TextInputType.number,
            hintText: '최대 $maxCount',
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              errorMsg ?? '',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          BottomBtn(
            label: '퀴즈 보기',
            onTap: () {
              String countStr = teCtl.text.trim();
              if (countStr == '' || countStr.isEmpty) {
                setState(() => errorMsg = '갯수를 입력해주세요');
                return;
              }

              int count = int.tryParse(countStr) ?? 0;
              if (count < 4) {
                setState(() => errorMsg = '4개 이상을 입력해주세요.');
                return;
              }
              if (count > maxCount) {
                setState(() => errorMsg = '$maxCount개 이하을 입력해주세요.');
                return;
              }
              Get.back(result: teCtl.text);
            },
          ),
          SizedBox(height: 10),
          Text(
            '랜덤 퀴즈는 점수에 반영되지 않습니다.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class RandomQuizDialog extends StatefulWidget {
  const RandomQuizDialog({super.key});

  @override
  State<RandomQuizDialog> createState() => RandomQuizDialogState();
}

class RandomQuizDialogState extends State<RandomQuizDialog> {
  late String _selected = '명사';

  @override
  void initState() {
    _selected = LocalReposotiry.getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: theme.colorScheme.surface,

      content: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 280, maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.quiz_rounded,
                  size: 20,
                  color: AppColors.mainBordColor,
                ),
                const SizedBox(width: 8),
                const Text('카테고리 선택', style: TextStyle(fontSize: 19)),
              ],
            ),
            SizedBox(height: 20),
            DropdownButtonFormField2<String>(
              value: _selected,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: '카테고리',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              items:
                  categoryList
                      .map(
                        (c) =>
                            DropdownMenuItem<String>(value: c, child: Text(c)),
                      )
                      .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selected = v);
              },
              buttonStyleData: const ButtonStyleData(padding: EdgeInsets.zero),
              iconStyleData: IconStyleData(
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 300,
                elevation: 2,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 24),
            BottomBtn(
              label: '퀴즈 보기',
              onTap: () {
                LocalReposotiry.changeCategory(_selected);
                Get.back(result: _selected);
              },
            ),
            SizedBox(height: 10),
            Text(
              '랜덤 퀴즈는 점수에 반영되지 않습니다.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

List<String> categoryList = [
  '랜덤',
  '명사',
  '동사',
  '형용사',
  '부사',
  '조사',
  '접속사',
  // '랜덤',
  // '감탄사',
  // '명사',
  // '동사',
  // '대명사',
  // '형용동사',
  // '조사',
  // '접사',
  // '형용사',
  // '부사',
];
