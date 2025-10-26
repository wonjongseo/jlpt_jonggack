import 'package:jlpt_jonggack/repository/grammar_step_repository.dart';
import 'package:jlpt_jonggack/repository/jlpt_step_repository.dart';
import 'package:jlpt_jonggack/repository/kangis_step_repository.dart';

class WordLoadService {
  static Future<List<int>> wordDataLoad(String language) async {
    List<int> wordCntPerLevel = [3195, 2586, 1537, 1018, 741];

    for (var n = 1; n <= 5; n++) {
      final exist = await JlptStepRepositroy.isExistData(n);

      /// 이미 데이터 저장됨.
      if (exist) {
        continue;
        wordCntPerLevel.add(
          await JlptStepRepositroy.getCountInJsonFile(language, '$n'),
        );
      } else {
        wordCntPerLevel[n - 1] = (await JlptStepRepositroy.init(
          language,
          '$n',
        ));
      }
    }
    print('wordCntPerLevel : ${wordCntPerLevel}');

    return wordCntPerLevel;
  }

  static Future<List<int>> kangiDataLoad(String language) async {
    List<int> kangiCntPerLevel = [951, 695, 184, 36, 81, 217];

    for (var n = 1; n <= 6; n++) {
      final exist = await KangiStepRepositroy.isExistData(n);

      /// 이미 데이터 저장됨.
      if (exist) {
        continue;
        kangiCntPerLevel.add(
          await KangiStepRepositroy.getCountInJsonFile(language, '$n'),
        );
      } else {
        kangiCntPerLevel[n - 1] = (await KangiStepRepositroy.init(
          language,
          '$n',
        ));
      }
    }
    print('kangiCntPerLevel : ${kangiCntPerLevel}');

    return kangiCntPerLevel;
  }

  static Future<List<int>> grammarDataLoad(String language) async {
    List<int> grammarCntPerLevel = [213, 174, 144, 49, 19];
    print("grammarDataLoad");
    for (var n = 1; n <= 5; n++) {
      final exist = await GrammarRepositroy.isExistData(n);
      print(exist);

      /// 이미 데이터 저장됨.
      if (exist) {
        continue;
        grammarCntPerLevel.add(
          await GrammarRepositroy.getCountInJsonFile(language, '$n'),
        );
      } else {
        grammarCntPerLevel[n - 1] = (await GrammarRepositroy.init(
          language,
          '$n',
        ));
      }
    }
    print('grammarCntPerLevel : ${grammarCntPerLevel}');

    return grammarCntPerLevel;
  }
}
