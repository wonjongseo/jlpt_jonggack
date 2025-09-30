import 'dart:developer';

import 'package:hive_flutter/adapters.dart';
import 'package:jlpt_jonggack/model/my_word.dart';

class MyWordRepository {
  Future<List<MyWord>> getAllMyWord(bool isManuelSave) async {
    final list = Hive.box<MyWord>(MyWord.boxKey);

    List<MyWord> words =
        List.generate(list.length, (index) {
          return list.getAt(index);
        }).whereType<MyWord>().where((element) {
          return element.isManuelSave == isManuelSave;
        }).toList();

    words.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

    return words;
  }

  Future<void> deleteMyWord(MyWord word) async {
    final list = Hive.box<MyWord>(MyWord.boxKey);

    await list.delete(word.word);
  }
}
