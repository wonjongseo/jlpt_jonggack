import 'package:hive/hive.dart';

import 'package:jlpt_jonggack/model/example.dart';
import 'package:jlpt_jonggack/model/grammar.dart';
import 'package:jlpt_jonggack/model/hive_type.dart';
import 'package:jlpt_jonggack/model/kangi.dart';
import 'package:jlpt_jonggack/model/word.dart';

part 'my_word.g.dart';

@HiveType(typeId: MyWordTypeId)
class MyWord {
  static String boxKey = 'my_word';
  @HiveField(0)
  late String word;
  @HiveField(1)
  late String mean;
  @HiveField(3)
  late String? yomikata = '';
  @HiveField(2)
  bool isKnown = false;
  @HiveField(4)
  late DateTime? createdAt;
  @HiveField(5)
  bool? isManuelSave = false;
  @HiveField(6)
  late List<Example> examples;

  @HiveField(7, defaultValue: false)
  late bool isGrammar;
  @HiveField(8)
  late String? connectionWays;
  @HiveField(9)
  late String? description;

  String getWord() {
    return word;
  }

  MyWord({
    required this.word,
    required this.mean,
    required this.yomikata,
    List<Example>? examples,
    this.isManuelSave = false,
    this.isGrammar = false,
    this.connectionWays,
    this.description,
  }) : examples =
           examples == null
               ? <Example>[]
               : List<Example>.from(
                 examples.map((e) => e.copyWith()), // deep copy 권장
               ),
       createdAt = DateTime.now();

  @override
  String toString() {
    return "MyWord{word: $word, mean: $mean, yomikata: $yomikata, isKnown: $isKnown, createdAt: $createdAt, isManuelSave: $isManuelSave, examples: $examples}";
  }

  MyWord.fromMap(Map<String, dynamic> map) {
    word = map['word'] ?? '';
    mean = map['mean'] ?? '';
    createdAt = map['createdAt'] ?? '';
    yomikata = map['yomikata'] ?? '';
    isGrammar = map['isGrammar'] ?? false;
    isKnown = false;
    examples = map['examples'] ?? [];
  }

  static MyWord kangiToMyWord(Kangi kangi) {
    MyWord newMyWord = MyWord(
      word: kangi.japan,
      mean: kangi.korea,
      yomikata: '${kangi.undoc} / ${kangi.hundoc}',
    );

    newMyWord.createdAt = DateTime.now();

    return newMyWord;
  }

  static MyWord grammerToWord(Grammar g) {
    return MyWord(
      word: g.grammar,
      mean: g.means,
      yomikata: '',
      description: g.description,
      connectionWays: g.connectionWays,
      examples: g.examples,
      isGrammar: true,
    );
  }

  static MyWord wordToMyWord(Word word) {
    MyWord newMyWord = MyWord(
      word: word.word,
      mean: word.mean,
      yomikata: word.yomikata,
      examples: word.examples,
    );
    newMyWord.createdAt = DateTime.now();

    return newMyWord;
  }

  String createdAtString() {
    return createdAt.toString().substring(0, 16);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyWord &&
        other.word == word &&
        other.mean == mean &&
        other.yomikata == yomikata;
  }

  @override
  int get hashCode {
    return word.hashCode ^
        mean.hashCode ^
        yomikata.hashCode ^
        isKnown.hashCode ^
        createdAt.hashCode ^
        isManuelSave.hashCode ^
        examples.hashCode;
  }
}
