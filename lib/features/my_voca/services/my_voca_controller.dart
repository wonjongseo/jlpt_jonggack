import 'dart:math';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/common/widget/custom_snack_bar.dart';
import 'package:jlpt_jonggack/model/word.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';
import 'dart:collection';

import 'package:jlpt_jonggack/common/admob/controller/ad_controller.dart';
import 'package:jlpt_jonggack/repository/my_word_repository.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../model/my_word.dart';

const MY_VOCA_TYPE = 'my-voca-type';

enum MyVocaEnum { MANUAL_SAVED_WORD, YOKUMATIGAERU_WORD }

class MyVocaControllerNew extends GetxController {
  MyWordRepository myWordReposotiry = MyWordRepository();
  late DateTime selectedDay;
  late DateTime focusedDay;
  DateTime now = DateTime.now();

  Map<DateTime, List<MyWord>> kEvents = {};
  Set<DateTime> selectedDays = LinkedHashSet<DateTime>(equals: isSameDay);

  late DateTime kFirstDay;
  late DateTime kLastDay;

  List<MyWord> _myword = [];
  List<MyWord> filteredMyword = [];

  @override
  void onInit() {
    kFirstDay = DateTime(2018);
    kLastDay = DateTime(now.year, now.month, now.day + 1);
    selectedDay = now;
    focusedDay = now;
    _loadData();
    super.onInit();
  }

  List<MyWord> getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  void onDaySelected(DateTime cSelectedDay, DateTime cFocusedDay) {
    selectedDay = cSelectedDay;
    focusedDay = cFocusedDay;

    if (selectedDays.contains(selectedDay)) {
      selectedDays.remove(selectedDay);
    } else {
      selectedDays.add(selectedDay);
    }
    filteredMyword = getEventsForDays(selectedDays);

    update();
  }

  List<MyWord> getEventsForDays(Set<DateTime> days) {
    return [for (final d in days) ...getEventsForDay(d)];
  }

  UserController userController = Get.find<UserController>();

  void updateWord(int index, bool isTrue) {
    myWordReposotiry.updateKnownMyVoca(filteredMyword[index].word, isTrue);
    update();
  }

  void deleteWord(int index) {
    MyWord myWord = filteredMyword[index];
    DateTime createdAy = DateTime.utc(
      myWord.createdAt!.year,
      myWord.createdAt!.month,
      myWord.createdAt!.day,
    );

    kEvents[createdAy]?.remove(myWord);

    userController.updateMyWordSavedCount(false, isYokumatiageruWord: true);

    MyWordRepository.deleteMyWord(myWord);
    filteredMyword = getEventsForDays(selectedDays);
    update();
  }

  void _loadData() async {
    _myword = await myWordReposotiry.getAllMyWord(false);
    // filteredMyword = List.from(_myword);

    kEvents = LinkedHashMap<DateTime, List<MyWord>>(
      equals: isSameDay,
      hashCode: getHashCode,
    );

    for (int i = 0; i < _myword.length; i++) {
      if (_myword[i].createdAt == null) {
        DateTime savedDate = DateTime.utc(now.year, now.month, now.day);
        kEvents.addAll({
          savedDate: [...kEvents[savedDate] ?? [], _myword[i]],
        });
      } else {
        DateTime savedDate = DateTime.utc(
          _myword[i].createdAt!.year,
          _myword[i].createdAt!.month,
          _myword[i].createdAt!.day,
        );
        kEvents.addAll({
          savedDate: [...kEvents[savedDate] ?? [], _myword[i]],
        });
      }
    }

    update();
  }

  int tS1selectedIndex = 0;
  int tS2selectedIndex = 0;

  bool isOnlyKnown = false;
  bool isOnlyUnKnown = false;
  bool isWordFlip = false;

  bool isOpenCalendar = true;

  void onToggleCalendar() {
    isOpenCalendar = !isOpenCalendar;
    filteredMyword = List.from(_myword);
    update();
  }

  String getWord(MyWord myWord) {
    String word = myWord.word;
    if (isWordFlip) {
      word = myWord.mean;
      if (myWord.mean.contains('\n')) {
        List<String> temp = myWord.mean.split('\n');
        int ranNum = Random().nextInt(temp.length);
        if (temp[ranNum].contains('. ')) {
          word = temp[ranNum].split('. ')[1];
        } else {
          word = temp[ranNum];
        }
      }
    }
    return word;
  }

  void onClickToggleSwitch1(int? selectedIndex) {
    if (selectedIndex == null) return;
    tS1selectedIndex = selectedIndex;
    switch (tS1selectedIndex) {
      case 0:
        isOnlyKnown = false;
        isOnlyUnKnown = false;
        break;
      case 1:
        isOnlyKnown = true;
        isOnlyUnKnown = false;
        break;
      case 2:
        isOnlyUnKnown = true;
        isOnlyKnown = false;
        break;
    }
    update();
  }

  void onClickToggleSwitch2(int? selectedIndex) {
    if (selectedIndex == null) return;
    tS2selectedIndex = selectedIndex;
    switch (tS2selectedIndex) {
      case 0:
        isWordFlip = false;
        break;
      case 1:
        isWordFlip = true;
        break;
      case 2:
        break;
    }
    update();
  }
}

class MyVocaController extends GetxController {
  bool isSeeAllData = true;

  void toggle() {
    isSeeAllData = !isSeeAllData;
    selectedWord = myWords;
    update();
  }

  int currentIndex = 0;
  void onPageChanged(int pageIndex) {
    currentIndex = pageIndex;
    update();
  }

  // for ad
  int saveWordCount = 0;
  final bool isManualSavedWordPage;
  bool isSeeMean = true;

  void toggleSeeMean(bool? v) {
    isSeeMean = v!;
    update();
  }

  bool isSeeYomikata = true;

  void toggleSeeYomikata(bool? v) {
    isSeeYomikata = v!;
    update();
  }
  // 키보드 On / OF

  // Flip 기능 종류
  bool isOnlyKnown = false;
  bool isOnlyUnKnown = false;
  bool isWordFlip = false;

  MyWordRepository myWordReposotiry = MyWordRepository();
  UserController userController = Get.find<UserController>();

  Map<DateTime, List<MyWord>> kEvents = {};
  List<MyWord> myWords = [];

  MyVocaController({required this.isManualSavedWordPage});

  void loadData() async {
    myWords = await myWordReposotiry.getAllMyWord(isManualSavedWordPage);

    DateTime now = DateTime.now();

    kEvents = LinkedHashMap<DateTime, List<MyWord>>(
      equals: isSameDay,
      hashCode: getHashCode,
    );

    for (int i = 0; i < myWords.length; i++) {
      if (myWords[i].createdAt == null) {
        DateTime savedDate = DateTime.utc(now.year, now.month, now.day);
        kEvents.addAll({
          savedDate: [...kEvents[savedDate] ?? [], myWords[i]],
        });
      } else {
        DateTime savedDate = DateTime.utc(
          myWords[i].createdAt!.year,
          myWords[i].createdAt!.month,
          myWords[i].createdAt!.day,
        );
        kEvents.addAll({
          savedDate: [...kEvents[savedDate] ?? [], myWords[i]],
        });
      }
    }
    int a = 0;
    for (var value in kEvents.values) {
      a += value.length;
    }
    print('a : ${a}');

    update();
  }

  void manualSaveMyWord(MyWord newWord) {
    if (kEvents[newWord.createdAt] == null) {
      kEvents[newWord.createdAt!] = [];
    }

    kEvents[newWord.createdAt]!.add(newWord);
    myWords.add(newWord);
    MyWordRepository.saveMyWord(newWord);

    selectedEvents.value.add(newWord);

    saveWordCount++;

    showSnackBar('${newWord.getWord()}가 저장되었습니다.');

    userController.updateMyWordSavedCount(true, isYokumatiageruWord: false);

    update();
  }

  @override
  void onInit() async {
    super.onInit();
    loadData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  int deleteArrayWords(
    List<MyWord> myWords, {
    bool isYokumatiageruWord = true,
  }) {
    int deleteWordsLength = myWords.length;
    for (int i = 0; i < deleteWordsLength; i++) {
      MyWord myWord = myWords[0];
      DateTime time = DateTime.utc(
        myWord.createdAt!.year,
        myWord.createdAt!.month,
        myWord.createdAt!.day,
      );

      kEvents[time]!.remove(myWord);
      selectedEvents.value.remove(myWord);

      userController.updateMyWordSavedCount(
        false,
        isYokumatiageruWord: isYokumatiageruWord,
      );

      MyWordRepository.deleteMyWord(myWord);
    }
    update();

    return deleteWordsLength;
  }

  void deleteWord(MyWord myWord, {bool isYokumatiageruWord = true}) {
    DateTime time = DateTime.utc(
      myWord.createdAt!.year,
      myWord.createdAt!.month,
      myWord.createdAt!.day,
    );

    kEvents[time]!.remove(myWord);
    selectedEvents.value.remove(myWord);

    userController.updateMyWordSavedCount(
      false,
      isYokumatiageruWord: isYokumatiageruWord,
    );

    MyWordRepository.deleteMyWord(myWord);
    update();
  }

  void updateWord(String word, bool isTrue) {
    myWordReposotiry.updateKnownMyVoca(word, isTrue);
    update();
  }

  int tS1selectedIndex = 0;
  int tS2selectedIndex = 0;

  void onClickToggleSwitch1(int? selectedIndex) {
    if (selectedIndex == null) return;
    tS1selectedIndex = selectedIndex;
    switch (tS1selectedIndex) {
      case 0:
        isOnlyKnown = false;
        isOnlyUnKnown = false;
        break;
      case 1:
        isOnlyKnown = true;
        isOnlyUnKnown = false;
        break;
      case 2:
        isOnlyUnKnown = true;
        isOnlyKnown = false;
        break;
    }
    update();
  }

  void onClickToggleSwitch2(int? selectedIndex) {
    if (selectedIndex == null) return;
    tS2selectedIndex = selectedIndex;
    switch (tS2selectedIndex) {
      case 0:
        isWordFlip = false;
        break;
      case 1:
        isWordFlip = true;
        break;
      case 2:
        break;
    }
    update();
  }

  void flip() {
    isWordFlip = !isWordFlip;
    update();
  }

  seeToReverse() {
    isWordFlip = !isWordFlip;

    update();
    Get.back();
  }

  List<MyWord> selectedWord = [];
  // Initaialize Calendar Things.

  final kToday = DateTime.now();

  CalendarFormat calendarFormat = CalendarFormat.twoWeeks;

  final ValueNotifier<List<MyWord>> selectedEvents = ValueNotifier([]);

  DateTime focusedDay = DateTime.now();
  final Set<DateTime> selectedDays = LinkedHashSet<DateTime>(equals: isSameDay);
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  List<MyWord> getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  List<MyWord> getEventsForDays(Set<DateTime> days) {
    print('getEventsForDays');
    return [for (final d in days) ...getEventsForDay(d)];
  }

  void onFormatChanged(format) {
    if (calendarFormat != format) {
      calendarFormat = format;

      update();
    }
  }

  // on Click Dat
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    focusedDay = focusedDay;
    if (selectedDays.contains(selectedDay)) {
      selectedDays.remove(selectedDay);
    } else {
      selectedDays.add(selectedDay);
    }

    update();

    selectedEvents.value = getEventsForDays(selectedDays);
    selectedWord = selectedEvents.value;
  }

  Future<int> postExcelData() async {
    UserController userController = Get.find<UserController>();

    bool result2 = true;
    if (!userController.user.isPremieum) {
      result2 = await CommonDialog.askSaveExcelDatasDialog();
    }

    if (!result2) {
      return 0;
    }
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
      allowMultiple: false,
    );

    int savedWordNumber = 0;
    int alreadySaveWordNumber = 0;
    if (pickedFile != null) {
      var bytes = pickedFile.files.single.bytes;

      var excel = Excel.decodeBytes(bytes!);

      try {
        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table]!.rows) {
            String word = (row[0] as Data).value.toString();
            word = word.replaceAll(RegExp('\\s'), "");

            String yomikata = (row[1] as Data).value.toString();
            yomikata = yomikata.replaceAll(RegExp('\\s'), "");

            String mean = (row[2] as Data).value.toString();
            mean = mean.replaceAll(RegExp('\\s'), "");

            MyWord newWord = MyWord(
              word: word,
              mean: mean,
              yomikata: yomikata,
              isManuelSave: true,
            );

            newWord.createdAt = DateTime.now();

            if (MyWordRepository.saveMyWord(newWord)) {
              savedWordNumber++;
            } else {
              alreadySaveWordNumber++;
            }
          }
        }
      } catch (e) {}
    }
    update();

    if (savedWordNumber != 0) {
      if (!userController.user.isPremieum) {
        // adController!.showRewardedInterstitialAd();
      }
    }
    return savedWordNumber;
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
