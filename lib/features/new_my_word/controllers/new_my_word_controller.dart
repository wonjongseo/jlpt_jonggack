import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jlpt_jonggack/common/app_constant.dart';
import 'package:jlpt_jonggack/common/utils/snackbar_helper.dart';
import 'package:jlpt_jonggack/common/widget/bottom_btn.dart';
import 'package:jlpt_jonggack/common/widget/custom_text_feild.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/jlpt_test/screens/jlpt_test_screen.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/new_grammar_test_screen.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/new_add_my_word_screen.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/new_my_word_study_screen.dart';
import 'package:jlpt_jonggack/features/setting/controller/font_size_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/features/setting/services/setting_repository.dart';
import 'package:jlpt_jonggack/model/book.dart';
import 'package:jlpt_jonggack/model/grammar_step.dart';
import 'package:jlpt_jonggack/model/my_word.dart';
import 'package:jlpt_jonggack/model/word.dart';
import 'package:jlpt_jonggack/repository/hive_repository.dart';
import 'package:jlpt_jonggack/repository/my_word_repository.dart';
import 'package:table_calendar/table_calendar.dart';

class NewMyWordController extends GetxController {
  static NewMyWordController get to => Get.find<NewMyWordController>();
  final MyWordRepository myWordRepository = MyWordRepository();

  final MyBookController myBookController;
  int selectedIndex = 0;

  NewMyWordController(this.myBookController);

  Book get book {
    return myBookController.selectedBook!;
  }

  final _isSelectedWord = true.obs;
  bool get isSelectedWord => _isSelectedWord.value;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _getLocalDBData();
    loadMyWords();
  }

  void autoUpdateWordInQuiz(Word word, bool value) {
    int index = -1;
    // MyWord updateMyWord = MyWord.wordToMyWord(word);
    for (var i = 0; i < allMyWords.length; i++) {
      if (allMyWords[i].word == word.word &&
          allMyWords[i].yomikata == word.yomikata) {
        index = i;
        break;
      }
    }
    if (index == -1) {
      return;
    }

    allMyWords[index].isKnown = value;
    MyBookController.to.updateMyWord(allMyWords[index]);
    update();
  }

  void updateWord(MyWord word) {
    word.isKnown = !word.isKnown;

    MyBookController.to.updateMyWord(word);
    update();
  }

  void goToQuiz({int backCnt = 0}) async {
    final result = await Get.dialog(
      name: 'InputQuizCntDialog',
      InputQuizCntDialog(maxCnt: allMyWords.length, isWord: isSelectedWord),
    );
    if (result == null) return;

    String quizCnt = result['quizCnt'];

    int iQuizCnt = int.tryParse(quizCnt) ?? 0;
    if (iQuizCnt < 1) {
      SnackBarHelper.showErrorSnackBar(AppString.plzEnterMoreOne.tr);
      return;
    } else if (iQuizCnt > allMyWords.length) {
      SnackBarHelper.showErrorSnackBar(
        isEn
            ? 'Please enter a number less than ${allMyWords.length}'
            : '${allMyWords.length}보다 작은 수를 입력해주세요',
      );
      return;
    }

    List<MyWord> tempWords = List.from(allMyWords);

    tempWords = tempWords.sublist(0, iQuizCnt);

    if (_isSelectedWord.value) {
      await Get.toNamed(
        JlptTestScreen.name,
        arguments: {MY_VOCA_TEST: tempWords, 'backCnt': backCnt},
      );
    } else {
      // 문법 일 경우
      if (iQuizCnt < 4) {
        SnackBarHelper.showErrorSnackBar(AppString.plzEnterMoreFour.tr);
        return;
      }

      final grammarStep = GrammarStep.fromMyWords(tempWords);

      await Get.toNamed(
        NewGrammarTestScreen.name,
        arguments: {
          'grammarStep': grammarStep,
          'isRecord': false,
          'isMyWord': true,
        },
      );
      loadMyWords();
    }
  }

  void goToAddMyWord() {
    Get.toNamed(NewAddMyWordScreen.name);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _getLocalDBData() {
    _isSelectedWord.value =
        SettingRepository.getBool(AppConstant.isSelectedWord) ?? true;
  }

  void toggleIsSelectedWord() {
    _isSelectedWord.value = !_isSelectedWord.value;

    // (선택) 탭 바꾸면 맨 위로
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }

    _applyCurrentFilters(); // ✅ 이게 핵심
    SettingRepository.setBool(
      AppConstant.isSelectedWord,
      _isSelectedWord.value,
    );
  }

  bool _matchWordOrGrammar(MyWord w) {
    if (_isSelectedWord.value) {
      return w.isGrammar != true; // 단어
    } else {
      return w.isGrammar == true; // 문법
    }
  }

  // 선택된 타입
  final _selectedType = MyWordType.all.obs;
  MyWordType get selectedType => _selectedType.value;

  // ✅ 타입 변경 시 표시 데이터 재적용
  void changeType(MyWordType? type) {
    if (type == null || _selectedType.value == type) return;
    _selectedType.value = type;

    try {
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    } catch (_) {}
    _applyCurrentFilters();
  }

  int _getIndexMapToList(int dateIndex, int wordIndex) {
    final map = myWordsMap.value;
    final days = map.keys.toList()..sort((a, b) => b.compareTo(a)); // 화면과 동일 순서

    if (dateIndex < 0 || dateIndex >= days.length) return -1;

    int index = 0;

    // 0 ~ (dateIndex-1) 날짜까지의 단어 수를 모두 합산
    for (int d = 0; d < dateIndex; d++) {
      index += map[days[d]]?.length ?? 0;
    }

    // 현재 날짜의 wordIndex 를 더함
    index += wordIndex;

    return index;
  }

  void goToStudyScreen(int dateIndex, int wordIndex) {
    final index = _getIndexMapToList(dateIndex, wordIndex);
    if (index < 0) return;

    selectedIndex = index;
    Get.to(() => NewMyWordStudyScreen());
  }

  MyWord? _getVisibleItem(int dateIndex, int wordIndex) {
    final keys = myWordsMap.value.keys.toList()..sort((a, b) => b.compareTo(a));
    if (dateIndex < 0 || dateIndex >= keys.length) return null;

    final day = keys[dateIndex];
    final bucket = myWordsMap.value[day];
    if (bucket == null || wordIndex < 0 || wordIndex >= bucket.length) {
      return null;
    }

    return bucket[wordIndex];
  }

  // _allList에서 동일 객체(참조) 우선, 아니면 키(단어+시간)로 찾기
  int _indexInAllList(MyWord target) {
    final i = _allList.indexWhere((w) => identical(w, target));
    if (i != -1) return i;

    final t = target.createdAt?.millisecondsSinceEpoch ?? -1;
    return _allList.indexWhere(
      (w) =>
          w.word == target.word &&
          (w.createdAt?.millisecondsSinceEpoch ?? -2) == t,
    );
  }

  void onScrollLeft(int dateIndex, int wordIndex) {
    final item = _getVisibleItem(dateIndex, wordIndex);
    if (item == null) return;

    final idx = _indexInAllList(item);
    if (idx < 0) return;

    // 토글
    updateWord(_allList[idx]);

    // 필터 상태(known/unKnown)에 따라 화면에서 사라지거나 나타나야 하므로 재적용
    _applyCurrentFilters();
    update();
  }

  void onScrollRight(int dateIndex, int wordIndex) {
    final item = _getVisibleItem(dateIndex, wordIndex);
    if (item == null) return;

    final idx = _indexInAllList(item);
    if (idx < 0) return;

    deleteWord(_allList[idx]);
  }

  void deleteWordInDetailPage(
    MyWord myWord, {
    bool isYokumatiageruWord = true,
  }) async {
    await deleteWord(myWord);

    if (_allList.isNotEmpty) {
      Get.off(() => NewMyWordStudyScreen(), preventDuplicates: false);
    } else {
      Get.back();
    }
  }

  Future<void> deleteWord(MyWord myWord) async {
    myBookController.deleteMyWord(myWord);
    await loadMyWords();
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // 전체 리스트(원본)
  final _allList = <MyWord>[].obs;

  // 🔽 유틸: 현재 보이는 날짜 키(최신순 정렬)
  List<DateTime> get _sortedVisibleDays {
    final keys = myWordsMap.value.keys.toList();
    keys.sort((a, b) => b.compareTo(a)); // 최신 날짜 우선
    return keys;
  }

  // 🔽 교체: 이제 allMyWords는 myWordsMap(=현재 선택된 날짜/범위 + 타입필터 반영)을 평탄화해서 반환
  List<MyWord> get allMyWords {
    final map = myWordsMap.value;
    if (map.isEmpty) return const <MyWord>[];

    final result = <MyWord>[];
    for (final day in _sortedVisibleDays) {
      final bucket = map[day];
      if (bucket != null && bucket.isNotEmpty) {
        // 주의: bucket 내부는 이미 _rebuildAllMap에서 최신순 정렬됨 + _applyCurrentFilters에서 타입 필터 적용됨
        result.addAll(bucket);
      }
    }
    return result;
  }

  // 날짜별 그룹 (전체용, 표시용)
  final _allMap = LinkedHashMap<DateTime, List<MyWord>>(
    equals: isSameDay,
    hashCode: _getHashCode,
  );

  // ✅ 외부에서 참조하는 맵: 항상 "현재 선택(전체/날짜/범위) + 타입"이 반영된 결과
  final myWordsMap =
      LinkedHashMap<DateTime, List<MyWord>>(
        equals: isSameDay,
        hashCode: _getHashCode,
      ).obs;

  // Range 상태
  final Rxn<DateTime> rangeStart = Rxn<DateTime>();
  final Rxn<DateTime> rangeEnd = Rxn<DateTime>();
  final selectedDay = Rxn<DateTime>();
  final focusedDay = DateTime.now().obs;

  bool get isRanged => rangeStart.value != null && rangeEnd.value != null;

  String get dateString {
    final fmt = DateFormat.yMMMd(Get.locale.toString());

    if (isRanged) {
      return '${fmt.format(rangeStart.value!)} ~ ${fmt.format(rangeEnd.value!)}';
    }

    if (rangeStart.value != null && rangeEnd.value == null) {
      return fmt.format(rangeStart.value!);
    }

    if (selectedDay.value != null) {
      return fmt.format(selectedDay.value!);
    }

    return AppString.allDay.tr;
  }

  final bookRepo = Get.find<HiveRepository<Book>>();
  Future<void> loadMyWords() async {
    try {
      _isLoading(true);

      List<MyWord> myWord = myBookController.selectedBook!.mywords;

      // 최신순 정렬
      myWord.sort((a, b) {
        final ad = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bd = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bd.compareTo(ad);
      });

      _allList.assignAll(myWord);
      _rebuildAllMap(myWord);

      // 초기: 전체 보기 + 타입 필터만 적용
      selectedDay.value = null;
      rangeStart.value = null;
      rangeEnd.value = null;
      focusedDay.value = DateTime.now();

      _applyCurrentFilters(); // ✅ 초기 화면 반영
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString(), isLog: true);
    } finally {
      _isLoading(false);
    }
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    if (!isSameDay(selectedDay.value, selected)) {
      selectedDay.value = selected;
      focusedDay.value = focused;
      // 단일일 선택 시 range 해제
      rangeStart.value = null;
      rangeEnd.value = null;
      _applyCurrentFilters(); // ✅ 타입 + 단일일 반영
    }
  }
  // 캘린더 상태

  static int _getHashCode(DateTime key) =>
      key.day * 1_000_000 + key.month * 10_000 + key.year;
  static DateTime _dayKey(DateTime dt) =>
      DateTime.utc(dt.year, dt.month, dt.day);

  // ✅ 타입 매칭 함수(공통 사용)
  bool _matchType(MyWord w) {
    switch (selectedType) {
      case MyWordType.known:
        return w.isKnown == true;
      case MyWordType.unKnown:
        return w.isKnown != true;
      case MyWordType.all:
        return true;
    }
  }

  // ✅ eventLoader도 타입 반영
  List<MyWord> getEventsForDay(DateTime day) {
    final key = _dayKey(day);
    final bucket = _allMap[key] ?? const <MyWord>[];
    return bucket
        .where((w) => _matchType(w) && _matchWordOrGrammar(w))
        .toList();
  }

  void _rebuildAllMap(List<MyWord> list) {
    _allMap.clear();
    for (final w in list) {
      final created = w.createdAt ?? DateTime.now();
      final key = _dayKey(created);
      final bucket = _allMap[key] ?? <MyWord>[];
      bucket.add(w);
      bucket.sort((a, b) {
        final ad = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bd = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bd.compareTo(ad);
      });
      _allMap[key] = bucket;
    }
  }

  /// 날짜 범위 적용
  void applyRange(DateTime? start, DateTime? end) {
    rangeStart.value = start;
    rangeEnd.value = end;

    try {
      if (start != null && end == null) {
        selectedDay.value = _dayKey(start);
        if (scrollController.hasClients) {
          scrollController.jumpTo(0);
        }
        _applyCurrentFilters();
        return;
      } else if (start == null || end == null) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(0);
        }
        clearRange();
        return;
      }
    } catch (_) {}
    // 단일일 해제하고 범위 적용
    selectedDay.value = null;

    _applyCurrentFilters(); // ✅ 타입 + 범위 반영
  }

  /// 날짜 범위 해제 (전체 보기)
  void clearRange() {
    rangeStart.value = null;
    rangeEnd.value = null;
    selectedDay.value = null;

    try {} catch (_) {}
    _applyCurrentFilters(); // ✅ 타입만 반영해 전체 보기
  }

  // ✅ 현재 조건(전체/단일일/범위) + 타입을 적용해 myWordsMap 갱신
  void _applyCurrentFilters() {
    final filtered = LinkedHashMap<DateTime, List<MyWord>>(
      equals: isSameDay,
      hashCode: _getHashCode,
    );

    DateTime? s, e;
    if (rangeStart.value != null && rangeEnd.value != null) {
      s = _dayKey(rangeStart.value!);
      e = _dayKey(rangeEnd.value!);
    } else if (selectedDay.value != null) {
      s = _dayKey(selectedDay.value!);
      e = s;
    }

    for (final entry in _allMap.entries) {
      final day = entry.key;
      if (s != null && e != null) {
        if (day.isBefore(s) || day.isAfter(e)) continue;
      }
      final bucket =
          entry.value
              .where((w) => _matchType(w) && _matchWordOrGrammar(w))
              .toList();
      if (bucket.isNotEmpty) {
        filtered[day] = bucket;
      }
    }

    myWordsMap.value
      ..clear()
      ..addAll(filtered);
    myWordsMap.refresh();
  }
}

class InputQuizCntDialog extends StatelessWidget {
  const InputQuizCntDialog({
    super.key,
    required this.maxCnt,
    required this.isWord,
  });
  final bool isWord;
  final int maxCnt;

  @override
  Widget build(BuildContext context) {
    bool isShowFourMore = !isWord && maxCnt < 4;

    TextEditingController teCrl = TextEditingController(
      text: maxCnt > 15 ? '15' : maxCnt.toString(),
    );
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppString.plzEnterNumberOfQuiz.tr,
            style: TextStyle(
              fontSize: FSController.to.baseFS,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (isShowFourMore) ...[
            SizedBox(height: 6),
            Text(
              AppString.plzFourMoreGrammar1.tr,
              style: TextStyle(
                fontSize: FSController.to.baseFS - 1,
                color: Colors.red,
              ),
            ),
          ],
          SizedBox(height: 12),
          Card(
            child: CustomTextFormField(
              autofocus: !isShowFourMore,
              readOnly: isShowFourMore,
              color: isShowFourMore ? Colors.grey : null,
              hintText: '15',
              controller: teCrl,
              sufficIcon: Text(
                isEn ? 'Up to $maxCnt words' : '최대 $maxCnt개',
                style: TextStyle(fontSize: FSController.to.baseFS - 2),
              ),
              keyboardType: TextInputType.number,
            ),
          ),

          SizedBox(height: 24),
          BottomBtn(
            label: AppString.confirm.tr,
            backgroundColor: isShowFourMore ? Colors.grey : null,
            onTap: () {
              if (isShowFourMore) {
                Get.back();
                return;
              }

              Get.back(result: {'quizCnt': teCrl.text});
            },
          ),
        ],
      ),
    );
  }
}
