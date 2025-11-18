import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jlpt_jonggack/common/app_constant.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/features/home/widgets/home_screen_body.dart';
import 'package:jlpt_jonggack/model/Question.dart';
import 'package:jlpt_jonggack/model/book.dart';
import 'package:jlpt_jonggack/model/example.dart';
import 'package:jlpt_jonggack/model/grammar.dart';
import 'package:jlpt_jonggack/model/grammar_step.dart';
import 'package:jlpt_jonggack/model/hive_type.dart';
import 'package:jlpt_jonggack/model/my_word.dart';
import 'package:jlpt_jonggack/model/jlpt_step.dart';
import 'package:jlpt_jonggack/model/kangi.dart';
import 'package:jlpt_jonggack/model/word.dart';
import 'package:jlpt_jonggack/model/kangi_step.dart';
import 'package:jlpt_jonggack/repository/hive_repository.dart';
import 'package:jlpt_jonggack/repository/my_word_repository.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';
import 'package:jlpt_jonggack/user/repository/user_repository.dart';

import '../model/user.dart';

class LocalReposotiry {
  static Future<void> init() async {
    if (GetPlatform.isMobile) {
      await Hive.initFlutter();
    }

    if (!Hive.isAdapterRegistered(KangiTypeId)) {
      Hive.registerAdapter(KangiAdapter());
    }
    if (!Hive.isAdapterRegistered(KangiStepTypeId)) {
      Hive.registerAdapter(KangiStepAdapter());
    }

    if (!Hive.isAdapterRegistered(WordTypeId)) {
      Hive.registerAdapter(WordAdapter());
    }
    if (!Hive.isAdapterRegistered(bookTypeId)) {
      Hive.registerAdapter(BookAdapter());
    }
    if (!Hive.isAdapterRegistered(MyWordTypeId)) {
      Hive.registerAdapter(MyWordAdapter());
    }
    if (!Hive.isAdapterRegistered(UserTypeId)) {
      Hive.registerAdapter(UserAdapter());
    }
    if (!Hive.isAdapterRegistered(JlptStepTypeId)) {
      Hive.registerAdapter(JlptStepAdapter());
    }

    if (!Hive.isAdapterRegistered(GrammarTypeId)) {
      Hive.registerAdapter(GrammarAdapter());
    }

    if (!Hive.isAdapterRegistered(GrammarStepTypeId)) {
      Hive.registerAdapter(GrammarStepAdapter());
    }

    if (!Hive.isAdapterRegistered(ExampleTypeId)) {
      Hive.registerAdapter(ExampleAdapter());
    }

    if (!Hive.isAdapterRegistered(QuestionTypeId)) {
      Hive.registerAdapter(QuestionAdapter());
    }

    if (!Hive.isBoxOpen(AppConstant.progressBox)) {
      await Hive.openBox(AppConstant.progressBox);
    }
    if (!Hive.isBoxOpen('homeTutorialKey')) {
      await Hive.openBox('homeTutorialKey');
    }

    if (!Hive.isBoxOpen(Book.boxKey)) {
      await Hive.openBox<Book>(Book.boxKey);
    }
    if (!Hive.isBoxOpen(MyWord.boxKey)) {
      await Hive.openBox<MyWord>(MyWord.boxKey);
    }
    if (!Hive.isBoxOpen(User.boxKey)) {
      await Hive.openBox(User.boxKey);
    }

    if (!Hive.isBoxOpen(Grammar.boxKey)) {
      await Hive.openBox<Grammar>(Grammar.boxKey);
    }
    if (!Hive.isBoxOpen(Kangi.boxKey)) {
      await Hive.openBox<Kangi>(Kangi.boxKey);
    }

    if (!Hive.isBoxOpen(JlptStep.boxKey)) {
      await Hive.openBox(JlptStep.boxKey);
    }

    if (!Hive.isBoxOpen(Example.boxKey)) {
      await Hive.openBox(Example.boxKey);
    }

    if (!Hive.isBoxOpen(Grammar.boxKey)) {
      await Hive.openBox(Grammar.boxKey);
    }

    if (!Hive.isBoxOpen(GrammarStep.boxKey)) {
      await Hive.openBox(GrammarStep.boxKey);
    }

    if (!Hive.isBoxOpen(KangiStep.boxKey)) {
      await Hive.openBox(KangiStep.boxKey);
    }

    if (!Hive.isBoxOpen(Word.boxKey)) {
      await Hive.openBox<Word>(Word.boxKey);
    }

    if (!Hive.isBoxOpen('usageCount')) {
      await Hive.openBox('usageCount');
    }

    if (!Hive.isBoxOpen('hasReviewed')) {
      await Hive.openBox('hasReviewed');
    }
    if (!Hive.isBoxOpen('lastRunDate')) {
      await Hive.openBox('lastRunDate');
    }
    if (!Hive.isBoxOpen(AppConstant.settingModelBox)) {
      await Hive.openBox(AppConstant.settingModelBox);
    }

    final bookRepo = HiveRepository<Book>(Book.boxKey);
    await bookRepo.initBox();
    Get.put<HiveRepository<Book>>(bookRepo);
  }

  static Future<void> migrationToBook(User user) async {
    MyWordRepository myWordRepository = MyWordRepository();
    List<MyWord> myWordBook1Words = await myWordRepository.getAllMyWord(false);

    List<Book> books = Book.createDefaultBooks();

    List<MyWord> myWordBook2Words = await myWordRepository.getAllMyWord(true);
    books[0].mywords = myWordBook1Words;
    books[1].mywords = myWordBook2Words;

    final bookRepo = Get.find<HiveRepository<Book>>();
    String book1Id = books[0].id;
    await bookRepo.put(book1Id, books[0]);

    String book2Id = books[1].id;
    await bookRepo.put(book2Id, books[1]);

    for (var word in myWordBook1Words) {
      await myWordRepository.deleteMyWord(word);
    }
    for (var word in myWordBook2Words) {
      await myWordRepository.deleteMyWord(word);
    }
  }

  static void setProgress(String key, int value) {
    final progressBox = Hive.box(AppConstant.progressBox);
    progressBox.put(key, value);
  }

  static int getProgress(String key) {
    final progressBox = Hive.box(AppConstant.progressBox);
    return progressBox.get(key) ?? 0;
  }

  static Future<void> deleteProgress() async {
    final progressBox = Hive.box(AppConstant.progressBox);
    await progressBox.deleteAll(progressBox.keys);
  }

  static bool isSeenHomeTutorial() {
    final homeTutorialBox = Hive.box('homeTutorialKey');
    String key = 'homeTutorial';

    if (!homeTutorialBox.containsKey(key)) {
      homeTutorialBox.put(key, true);
      return false;
    }

    if (homeTutorialBox.get(key) == false) {
      homeTutorialBox.put(key, true);
      return false;
    }

    return true;
  }

  static int aaa() {
    final list = Hive.box('usageCount');
    int usageCount = list.get('usageCount', defaultValue: 0) + 1;

    list.put('usageCount', usageCount);

    return usageCount;
  }

  static bool bbb() {
    final list = Hive.box('hasReviewed');

    return list.get('hasReviewed', defaultValue: false);
  }

  static void ccc() {
    final list = Hive.box('hasReviewed');

    list.put('hasReviewed', true);
  }

  static Future<void> saveLastRunDate() async {
    final list = Hive.box('lastRunDate');
    list.put('lastRunDate', DateTime.now().millisecondsSinceEpoch);
  }

  static Future<bool> is30DaysPassed() async {
    final list = Hive.box('lastRunDate');

    int? lastRunDate = list.get('lastRunDate');

    if (lastRunDate == null) {
      await saveLastRunDate();
      return false;
    }

    DateTime lastRun = DateTime.fromMillisecondsSinceEpoch(lastRunDate);

    DateTime currentDate = DateTime.now();

    Duration difference = currentDate.difference(lastRun);

    return difference.inDays >= 30;
  }

  static Future<bool> checkAndExecuteFunction() async {
    if (await is30DaysPassed()) {
      await saveLastRunDate();
      return true;
    }
    return false;
  }
}
