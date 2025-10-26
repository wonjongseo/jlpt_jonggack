// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

class AppConstant {
  // 챕터 당 단어 수
  static const int MINIMUM_STEP_COUNT = kDebugMode ? 4 : 15; //TODO

  // 자주 틀리는 문제로 유도하는 [모르는 버튼] 누른 숫자 MIN = 15 AND MAX = 10
  // ACTUALLY MIN 15 <= x <= 30
  static const int INDUCE_USUALLY_WRONG_VOCA_PAGE_COUNT_MIN = 15;
  static const int INDUCE_USUALLY_WRONG_VOCA_PAGE_COUNT_MAX = 15;
  // static const int HERAT_COUNT_MAX = 30;

  static const String settingModelBox = 'settingsBox';
  static const String settingLanguageKey = 'settingLanguage';
  static const String isDarkModeKey = 'isDarkModeKey';

  // Tts
  static const String speechRateKey = 'speechRateKey';
  static const String volumnKey = 'volumnKey';
  static const String pitchKey = 'pitchKey';

  // Quiz
  static const String incorrectDurationKey = 'incorrectDurationKey';
  static const String correctDurationKey = 'correctDurationKey';
}

class HVKey {
  static const String settingModelBox = 'settings';
}

class AppConstantMsg {
  static const String initDataAlertMsg = '점수들도 함께 사라집니다.\n그래도 진행하시겠습니까?';
}
