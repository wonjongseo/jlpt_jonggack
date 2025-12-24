import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:jlpt_jonggack/common/app_constant.dart';

import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/common/widget/custom_text_feild.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/features/grammar_test/grammar_test_screen.dart';
import 'package:jlpt_jonggack/features/jlpt_test/screens/jlpt_test_screen.dart';
import 'package:jlpt_jonggack/features/kangi_test/kangi_test_screen.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/new_grammar_test_screen.dart';
import 'package:jlpt_jonggack/model/grammar.dart';
import 'package:jlpt_jonggack/model/grammar_step.dart';
import 'package:jlpt_jonggack/model/jlpt_step.dart';
import 'package:jlpt_jonggack/model/kangi.dart';
import 'package:jlpt_jonggack/model/kangi_step.dart';
import 'package:jlpt_jonggack/model/word.dart';
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

    // List<String> categories = [];

    // switch (category) {
    //   case '명사':
    //     categories.addAll(['명사', '대명사']);
    //     break;
    //   case '동사':
    //     categories.addAll(['동사']);
    //     break;
    //   case '형용사':
    //     categories.addAll(['형용사', '형용동사']);
    //     break;
    //   case '부사':
    //     categories.addAll(['부사']);
    //     break;
    //   case '조사':
    //     categories.addAll(['조사']);
    //     break;
    //   case '접속사':
    //     categories.addAll(['접사']);
    //     break;
    // }
    Random random = Random();

    while (words.length < count) {
      int randomIdx = random.nextInt(tempWords.length);
      Word word = tempWords[randomIdx];

      if (words.contains(word)) {
        continue;
      }
      words.add(word);
      // if (category == '랜덤' || word.category == null) {
      //   words.add(word);
      // } else {
      //   String wordCategory = word.category!.split(' ')[0];

      //   if (categories.contains(wordCategory)) {
      //     words.add(word);
      //   } else {
      //     continue;
      //   }
      // }
    }

    return words;
  }

  static Future<List<Word>> getAllJapaneseByLevel(
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
            print("continue");
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
        jlptStep = jlptStep as KangiStep;
        if (!isPremium && level == 1) {
          String sChapter = jlptStep.headTitle.split('챕터')[1];

          int chapter = int.tryParse(sChapter) ?? 100;
          if (chapter > 3) {
            print("continue");
            continue;
          }
        }
        tempKangis.addAll((jlptStep).kangis);
      }
    }
    return tempKangis;
  }

  static Future<List<Grammar>> getAllGrammarByLevel(
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
        if (!isPremium && level == 1) {
          if (int.parse(x) > 2) {
            print("continue");
            continue;
          }
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
          UserController.to.user!.isPremieum || UserController.to.user!.isTrik;
    }
    List<Word> tempWords = [];
    List<Grammar> tempGrammars = [];
    List<Kangi> tempKangis = [];

    switch (category) {
      case CategoryEnum.japaneses:
        tempWords = await getAllJapaneseByLevel(level, isPremium);

        List<Word> words = await _createJlptQuiz(
          level,
          AppConstant.MINIMUM_STEP_COUNT,
          tempWords,
          '랜덤',
        );

        Get.toNamed(
          JlptTestScreen.name,
          arguments: {JLPT_TEST: words, IS_RANDOM: true},
        );
        break;
      case CategoryEnum.kangis:
        tempKangis = await _getAllKangisByLevel(level, isPremium);

        List<Kangi> kangis = await _createKangiQuiz(
          level,
          AppConstant.MINIMUM_STEP_COUNT,
          tempKangis,
        );
        Get.toNamed(
          KangiTestScreen.name,
          arguments: {KANGI_TEST: kangis, IS_RANDOM: true},
        );
        break;
      case CategoryEnum.grammars:
        tempGrammars = await getAllGrammarByLevel(level, isPremium);

        List<Grammar> grammars = await _createGrammarQuiz(
          level,
          AppConstant.MINIMUM_STEP_COUNT,
          tempGrammars,
        );

        final grammarStep = GrammarStep(
          level: 'random',
          step: 0,
          grammars: grammars,
        );
        Get.toNamed(
          NewGrammarTestScreen.name,
          arguments: {
            'grammarStep': grammarStep,
            'isMyWord': false,
            'isRandom': true,
          },
        );
    }
  }
}

// class RandomQuizDialog extends StatefulWidget {
//   const RandomQuizDialog({super.key});

//   @override
//   State<RandomQuizDialog> createState() => RandomQuizDialogState();
// }

// class RandomQuizDialogState extends State<RandomQuizDialog> {
//   late String _selected = '명사';

//   @override
//   void initState() {
//     _selected = LocalReposotiry.getCategory();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       backgroundColor: theme.colorScheme.surface,

//       content: ConstrainedBox(
//         constraints: const BoxConstraints(minWidth: 280, maxWidth: 360),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.quiz_rounded,
//                   size: 20,
//                   color: AppColors.mainBordColor,
//                 ),
//                 const SizedBox(width: 8),
//                 const Text('카테고리 선택', style: TextStyle(fontSize: 19)),
//               ],
//             ),
//             SizedBox(height: 20),
//             DropdownButtonFormField2<String>(
//               value: _selected,
//               isExpanded: true,
//               decoration: InputDecoration(
//                 labelText: '카테고리',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 12,
//                 ),
//               ),
//               items:
//                   categoryList
//                       .map(
//                         (c) =>
//                             DropdownMenuItem<String>(value: c, child: Text(c)),
//                       )
//                       .toList(),
//               onChanged: (v) {
//                 if (v != null) setState(() => _selected = v);
//               },
//               buttonStyleData: const ButtonStyleData(padding: EdgeInsets.zero),
//               iconStyleData: IconStyleData(
//                 icon: Icon(
//                   Icons.keyboard_arrow_down_rounded,
//                   color: theme.colorScheme.onSurfaceVariant,
//                 ),
//               ),
//               dropdownStyleData: DropdownStyleData(
//                 maxHeight: 300,
//                 elevation: 2,
//                 decoration: BoxDecoration(
//                   color: theme.colorScheme.surface,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               menuItemStyleData: const MenuItemStyleData(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//               ),
//             ),
//             const SizedBox(height: 24),
//             BottomBtn(
//               label: '퀴즈 보기',
//               onTap: () {
//                 LocalReposotiry.changeCategory(_selected);
//                 Get.back(result: _selected);
//               },
//             ),
//             SizedBox(height: 10),
//             Text(
//               '랜덤 퀴즈는 점수에 반영되지 않습니다.',
//               style: TextStyle(fontSize: 12, color: Colors.black54),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// List<String> categoryList = [
//   '랜덤',
//   '명사',
//   '동사',
//   '형용사',
//   '부사',
//   '조사',
//   '접속사',
//   // '랜덤',
//   // '감탄사',
//   // '명사',
//   // '동사',
//   // '대명사',
//   // '형용동사',
//   // '조사',
//   // '접사',
//   // '형용사',
//   // '부사',
// ];
