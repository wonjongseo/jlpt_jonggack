// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:hive/hive.dart';
import 'package:jlpt_jonggack/common/network_manager.dart';
import 'package:jlpt_jonggack/features/setting/screen/setting_screen.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/word.dart';

import 'hive_type.dart';

part 'kangi.g.dart';

@HiveType(typeId: KangiTypeId)
class Kangi extends HiveObject {
  static String boxKey = 'kangi_key';
  @HiveField(0)
  late String japan;
  @HiveField(1)
  late String korea;
  @HiveField(2)
  late String headTitle;
  @HiveField(3)
  late String undoc;
  @HiveField(4)
  late String hundoc;
  @HiveField(5)
  late List<Word> relatedVoca;

  @HiveField(6, defaultValue: '')
  late String english;

  String get mean {
    return isKo ? korea : english;
  }

  String get shortMean {
    if (isKo) {
      return korea;
    }

    final splited = english.split(',');
    if (splited.isEmpty || splited.length == 1) {
      return english;
    } else {
      return '${splited[0]}...';
    }
  }

  Kangi({
    required this.japan,
    required this.korea,
    required this.headTitle,
    required this.undoc,
    required this.hundoc,
    required this.relatedVoca,
    required this.english,
  });

  Kangi.fromMap(Map<String, dynamic> map) {
    japan = map['japan'] ?? '';
    korea = map['korea'] ?? '';
    headTitle = map['headTitle'] ?? '';
    undoc = map['undoc'] ?? '';
    hundoc = map['hundoc'] ?? '';
    english = map['english'];
    relatedVoca = List.generate(
      map['relatedVoca'].length,
      (index) => Word.fromMap(map['relatedVoca'][index]),
    );
  }

  @override
  String toString() {
    return "Kangi( Japan: $japan, korea: $korea, undoc: $undoc, headTitle: $headTitle, relatedVoca: $relatedVoca)";
  }

  static Future<List<List<Kangi>>> jsonToObject(
    String language,
    String nLevel,
  ) async {
    List<List<Kangi>> kangis = [];

    var selectedKangiLevelJson = await NetWorkManager.getDataToServer(
      'kangis/n$nLevel',
    );

    for (int i = 0; i < selectedKangiLevelJson.length; i++) {
      List<Kangi> temp = [];
      for (int j = 0; j < selectedKangiLevelJson[i].length; j++) {
        temp.add(Kangi.fromMap(selectedKangiLevelJson[i][j]));
      }

      kangis.add(temp);
    }

    return kangis;
  }

  // @ 으로 음독 , 훈독 구별
  Word kangiToWord() {
    return Word(
      word: japan,
      mean: mean,
      yomikata: '${undoc}@${hundoc}',
      headTitle: headTitle,
    );
  }
}
