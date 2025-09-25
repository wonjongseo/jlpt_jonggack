import 'dart:collection';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/utils/snackbar_helper.dart';
import 'package:jlpt_jonggack/features/jlpt_test/screens/jlpt_test_screen.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/new_my_word_study_screen.dart';
import 'package:jlpt_jonggack/model/my_word.dart';
import 'package:jlpt_jonggack/repository/my_word_repository.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';
import 'package:table_calendar/table_calendar.dart';

enum MyWordType {
  all("모두 보기"),
  known("암기 단어"),
  unKnown("미암기 단어");

  final String label;
  const MyWordType(this.label);
}

class MyWordNewController extends GetxController {
  static MyWordNewController get to => Get.find<MyWordNewController>();
  final MyWordRepository myWordRepository = MyWordRepository();
  final bool isManualSavedWordPage;
  int selectedIndex = 0;

  MyWordNewController(this.isManualSavedWordPage);

  // 선택된 타입
  final _selectedType = MyWordType.all.obs;
  MyWordType get selectedType => _selectedType.value;

  // ✅ 타입 변경 시 표시 데이터 재적용
  void changeType(MyWordType? type) {
    if (type == null) return;
    _selectedType.value = type;
    _applyCurrentFilters();
  }

  int _getIndexMapToList(int dateIndex, int wordIndex) {
    int index = 0;
    if (dateIndex != 0) {
      final wordPerDate = _allMap.values.toList()[dateIndex - 1];
      index = (dateIndex * wordPerDate.length) + wordIndex;
    } else {
      index = dateIndex + wordIndex;
    }
    return index;
  }

  MyWord? _getVisibleItem(int dateIndex, int wordIndex) {
    final keys = myWordsMap.value.keys.toList()..sort((a, b) => b.compareTo(a));
    if (dateIndex < 0 || dateIndex >= keys.length) return null;

    final day = keys[dateIndex];
    final bucket = myWordsMap.value[day];
    if (bucket == null || wordIndex < 0 || wordIndex >= bucket.length)
      return null;

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
    _allList[idx].isKnown = !_allList[idx].isKnown;
    myWordRepository.updateKnownMyVoca2(_allList[idx]);

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
    loadMyWords();
  }

  void deleteWord(MyWord myWord, {bool isYokumatiageruWord = true}) {
    UserController.to.updateMyWordSavedCount(
      false,
      isYokumatiageruWord: isYokumatiageruWord,
    );
    MyWordRepository.deleteMyWord(myWord);
    update();
  }

  void goToStudyScreen(int dateIndex, int wordIndex) {
    int index = _getIndexMapToList(dateIndex, wordIndex);
    selectedIndex = index;
    Get.to(() => NewMyWordStudyScreen());
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // 전체 리스트(원본)
  final _allList = <MyWord>[].obs;

  // ✅ 외부에서 참조하는 getter: 타입 필터 적용
  List<MyWord> get allMyWords {
    final result = <MyWord>[];
    for (final w in _allList) {
      // switch-filter
      switch (selectedType) {
        case MyWordType.known:
          if (!w.isKnown) continue;
          break;
        case MyWordType.unKnown:
          if (w.isKnown) continue;
          break;
        case MyWordType.all:
          break;
      }
      result.add(w);
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

  bool get isRanged => rangeStart.value != null || rangeEnd.value != null;

  // 캘린더 상태
  final selectedDay = Rxn<DateTime>();
  final focusedDay = DateTime.now().obs;

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
    return bucket.where(_matchType).toList();
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
      final bucket = entry.value.where(_matchType).toList();
      if (bucket.isNotEmpty) {
        filtered[day] = bucket;
      }
    }

    myWordsMap.value
      ..clear()
      ..addAll(filtered);
    myWordsMap.refresh();
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

  Future<void> loadMyWords() async {
    try {
      _isLoading(true);
      final items = await myWordRepository.getAllMyWord(isManualSavedWordPage);

      // 최신순 정렬
      items.sort((a, b) {
        final ad = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bd = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bd.compareTo(ad);
      });

      _allList.assignAll(items);
      _rebuildAllMap(items);

      // 초기: 전체 보기 + 타입 필터만 적용
      selectedDay.value = null;
      rangeStart.value = null;
      rangeEnd.value = null;
      focusedDay.value = DateTime.now();

      _applyCurrentFilters(); // ✅ 초기 화면 반영
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString());
    } finally {
      _isLoading(false);
    }
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

    if (start != null && end == null) {
      // 단일일로 간주
      selectedDay.value = _dayKey(start);
      _applyCurrentFilters();
      return;
    } else if (start == null || end == null) {
      clearRange();
      return;
    }

    // 단일일 해제하고 범위 적용
    selectedDay.value = null;
    _applyCurrentFilters(); // ✅ 타입 + 범위 반영
  }

  /// 날짜 범위 해제 (전체 보기)
  void clearRange() {
    rangeStart.value = null;
    rangeEnd.value = null;
    selectedDay.value = null;
    _applyCurrentFilters(); // ✅ 타입만 반영해 전체 보기
  }

  @override
  void onInit() {
    super.onInit();
    loadMyWords();
  }

  void updateWord(String word, bool isTrue) {
    myWordRepository.updateKnownMyVoca(word, isTrue);
  }

  void goToQuiz() {
    Get.toNamed(JLPT_TEST_PATH, arguments: {MY_VOCA_TEST: allMyWords});
  }
}
