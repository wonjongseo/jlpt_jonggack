import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:jlpt_jonggack/common/common.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/model/jlpt_step.dart';
import 'package:jlpt_jonggack/model/word.dart';
import 'package:jlpt_jonggack/repository/kangis_step_repository.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';

import '../common/app_constant.dart';

class JlptRepositry {
  static Future<Word?> searchWord(String query) async {
    final wordBox = Hive.box<Word>(Word.boxKey);
    Word? word = wordBox.get(query);

    return word;
  }

  static Future<List<Word>> searchWords(String query) async {
    final wordBox = Hive.box<Word>(Word.boxKey);

    List<Word> relatedWords =
        wordBox.values.where((element) {
          if (element.word.contains(query) ||
              element.yomikata.contains(query) ||
              element.mean.contains(query)) {
            return true;
          }
          return false;
        }).toList();

    List<Word> words =
        wordBox.values.where((element) {
          if (element.word == (query) ||
              element.yomikata == (query) ||
              element.mean == (query)) {
            return true;
          }
          return false;
        }).toList();
    if (words.isEmpty) {
      return relatedWords;
    } else {
      return words;
    }
  }
}

class JlptStepRepositroy {
  static Future<bool> isExistData(int nLevel) async {
    final box = Hive.box(JlptStep.boxKey);

    int jlptHeadTieleCount = await box.get(
      '$nLevel-step-count',
      defaultValue: 0,
    );

    return jlptHeadTieleCount != 0;
  }

  static Future<int> getCountInJsonFile(String language, String nLevel) async {
    List<List<Word>> words = await Word.jsonToObject(language, nLevel);
    int totalCount = 0;

    for (int i = 0; i < words.length; i++) {
      totalCount += words[i].length;
    }
    return totalCount;
  }

  static Future<void> deleteAllWord() async {
    log('deleteAllWord start');

    final jlptStepBox = Hive.box(JlptStep.boxKey);
    final wordBox = Hive.box<Word>(Word.boxKey);
    await wordBox.deleteAll(wordBox.keys);
    await jlptStepBox.deleteAll(jlptStepBox.keys);
  }

  static Future<int> init(String language, String nLevel) async {
    log('JlptStepRepositroy ${nLevel}N init');

    final box = Hive.box(JlptStep.boxKey);
    final wordBox = Hive.box<Word>(Word.boxKey);

    List<List<Word>> words = await Word.jsonToObject(language, nLevel);

    int totalCount = 0;

    for (int i = 0; i < words.length; i++) {
      totalCount += words[i].length;
    }

    log('totalCount: $totalCount');
    box.put('$nLevel-step-count', words.length);

    for (int hiraganaIndex = 0; hiraganaIndex < words.length; hiraganaIndex++) {
      String hiragana = words[hiraganaIndex][0].headTitle;

      int wordsLengthByHiragana = words[hiraganaIndex].length;
      int stepCount = 0;

      for (
        int step = 0;
        step < wordsLengthByHiragana;
        step += AppConstant.MINIMUM_STEP_COUNT
      ) {
        List<Word> currentWords = [];

        if (step + AppConstant.MINIMUM_STEP_COUNT > wordsLengthByHiragana) {
          currentWords = words[hiraganaIndex].sublist(step);
        } else {
          currentWords = words[hiraganaIndex].sublist(
            step,
            step + AppConstant.MINIMUM_STEP_COUNT,
          );
        }

        for (Word word in currentWords) {
          KangiStepRepositroy kangiStepRepositroy = KangiStepRepositroy();
          getKangiIndex(word.word, kangiStepRepositroy);
          await wordBox.put(word.word, word);
        }
        JlptStep tempJlptStep = JlptStep(
          headTitle: hiragana,
          step: stepCount,
          words: currentWords,
          scores: 0,
        );

        String key = '$nLevel-$hiragana-$stepCount';
        getProgress('${CategoryEnum.japaneses.name}-$nLevel-$hiragana', 0);
        await box.put(key, tempJlptStep);
        stepCount++;
      }

      await box.put('$nLevel-$hiragana', stepCount);
    }
    getProgress('${CategoryEnum.japaneses.name}-$nLevel', 0);

    return totalCount;
  }

  static getProgress(String key, int index) {
    LocalReposotiry.setProgress(key, index);
  }

  List<JlptStep> getJlptStepByHeadTitle(String nLevel, String headTitle) {
    final box = Hive.box(JlptStep.boxKey);

    int headTitleStepCount = box.get('$nLevel-$headTitle');

    List<JlptStep> jlptStepList = [];

    for (int step = 0; step < headTitleStepCount; step++) {
      String key = '$nLevel-$headTitle-$step';
      JlptStep jlptStep = box.get(key);
      jlptStepList.add(jlptStep);
    }
    return jlptStepList;
  }

  int getCountByJlptHeadTitle(String nLevel) {
    final box = Hive.box(JlptStep.boxKey);

    int jlptHeadTieleCount = box.get('$nLevel-step-count', defaultValue: 0);

    return jlptHeadTieleCount;
  }

  void updateJlptStep(String nLevel, JlptStep newJlptStep) {
    final box = Hive.box(JlptStep.boxKey);

    String key = '$nLevel-${newJlptStep.headTitle}-${newJlptStep.step}';
    box.put(key, newJlptStep);
  }

  static Future<int> updateJlptStepData(String language, String nLevel) async {
    log('JlptStepRepositroy ${nLevel}N Update');

    final box = Hive.box(JlptStep.boxKey);
    final wordBox = Hive.box<Word>(Word.boxKey);

    List<List<Word>> words = await Word.jsonToObject(language, nLevel);
    int totalCount = 0;

    for (int i = 0; i < words.length; i++) {
      totalCount += words[i].length;
    }
    log('totalCount: $totalCount');

    box.put('$nLevel-step-count', words.length);

    for (int hiraganaIndex = 0; hiraganaIndex < words.length; hiraganaIndex++) {
      String hiragana = words[hiraganaIndex][0].headTitle;

      int wordsLengthByHiragana = words[hiraganaIndex].length;
      int stepCount = 0;

      for (
        int step = 0;
        step < wordsLengthByHiragana;
        step += AppConstant.MINIMUM_STEP_COUNT
      ) {
        List<Word> currentWords = [];

        if (step + AppConstant.MINIMUM_STEP_COUNT > wordsLengthByHiragana) {
          currentWords = words[hiraganaIndex].sublist(step);
        } else {
          currentWords = words[hiraganaIndex].sublist(
            step,
            step + AppConstant.MINIMUM_STEP_COUNT,
          );
        }

        for (Word word in currentWords) {
          KangiStepRepositroy kangiStepRepositroy = KangiStepRepositroy();
          getKangiIndex(word.word, kangiStepRepositroy);
          await wordBox.put(word.word, word);
        }
        String key = '$nLevel-$hiragana-$stepCount';

        JlptStep? beforeJlptStep = await box.get(key);

        if (beforeJlptStep == null) break; //return totalCount;
        beforeJlptStep.words = currentWords;

        // getProgress('${CategoryEnum.japaneses.name}-$nLevel-$hiragana', 0);
        await box.put(key, beforeJlptStep);
        stepCount++;
      }

      await box.put('$nLevel-$hiragana', stepCount);
    }
    // getProgress('${CategoryEnum.japaneses.name}-$nLevel', 0);

    return totalCount;
  }
}
