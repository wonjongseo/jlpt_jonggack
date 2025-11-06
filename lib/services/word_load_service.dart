import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/repository/grammar_step_repository.dart';
import 'package:jlpt_jonggack/repository/jlpt_step_repository.dart';
import 'package:jlpt_jonggack/repository/kangis_step_repository.dart';

class WordLoadService {
  static Future<List<int>> wordDataLoad(String language) async {
    print('wordDataLoad $language');
    List<int> wordCntPerLevel = [];

    for (var n = 1; n <= 5; n++) {
      final exist = await JlptStepRepositroy.isExistData(n);

      if (exist) {
        wordCntPerLevel.add(
          await JlptStepRepositroy.getCountInJsonFile(language, '$n'),
        );
      } else {
        wordCntPerLevel.add(await JlptStepRepositroy.init(language, '$n'));
      }
    }

    return wordCntPerLevel;
  }

  static Future<List<int>> updateWordData(String language) async {
    print('updateWordData $language');
    List<int> wordCntPerLevel = [];

    for (var n = 1; n <= 5; n++) {
      int count = await JlptStepRepositroy.updateJlptStepData(
        SettingController.to.systemLocale!.languageCode,
        "$n",
      );

      wordCntPerLevel.add(count);
    }

    return wordCntPerLevel;
  }

  static Future<List<int>> kangiDataLoad(String language) async {
    print('kangiDataLoad $language');
    List<int> kangiCntPerLevel = [];

    for (var n = 1; n <= 6; n++) {
      final exist = await KangiStepRepositroy.isExistData(n);

      /// 이미 데이터 저장됨.
      if (exist) {
        kangiCntPerLevel.add(
          await KangiStepRepositroy.getCountInJsonFile(language, '$n'),
        );
      } else {
        kangiCntPerLevel.add(await KangiStepRepositroy.init(language, '$n'));
      }
    }

    return kangiCntPerLevel;
  }

  static Future<List<int>> updateKangisData(String language) async {
    print('updateKangisData $language');
    List<int> kangiCntPerLevel = [];

    for (var n = 1; n <= 6; n++) {
      kangiCntPerLevel.add(
        await KangiStepRepositroy.updateKangiStepData(
          SettingController.to.systemLocale!.languageCode,
          "$n",
        ),
      );
    }

    return kangiCntPerLevel;
  }

  static Future<List<int>> grammarDataLoad(String language) async {
    print('grammarDataLoad $language');
    List<int> grammarCntPerLevel = [];

    for (var n = 1; n <= 5; n++) {
      final exist = await GrammarRepositroy.isExistData(n);

      /// 이미 데이터 저장됨.
      if (exist) {
        grammarCntPerLevel.add(
          await GrammarRepositroy.getCountInJsonFile(language, '$n'),
        );
      } else {
        grammarCntPerLevel.add(await GrammarRepositroy.init(language, '$n'));
      }
    }

    return grammarCntPerLevel;
  }

  static Future<List<int>> updateGrammarData(String language) async {
    print('updateGrammarData $language');
    List<int> grammarCntPerLevel = [];

    for (var n = 1; n <= 5; n++) {
      grammarCntPerLevel.add(
        await GrammarRepositroy.updateGrammarStepData(
          SettingController.to.systemLocale!.languageCode,
          "$n",
        ),
      );
    }

    return grammarCntPerLevel;
  }
}
