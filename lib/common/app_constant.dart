// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

class AppConstant {
  // 챕터 당 단어 수
  static const int MINIMUM_STEP_COUNT = kDebugMode ? 8 : 15; //TODO

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

  static const String isAlertGrantedKey = 'isAlertGrantedKey';
  static const String isDarkMode = 'isDarkMode';
  static const String fontSizeKey = 'fontSizeKey';

  static const String basicOrJlptOrMyKey = 'basicOrJlptOrMy';
  static const String progressBox = 'progressBox';
  static const String progressKey = 'basicOrJlptOrMyKey';

  static const String isUpdated = 'isUpdatedKey';
}

class HVKey {
  static const String settingModelBox = 'settings';
}

class AppConstantMsg {
  static const String initDataAlertMsg = '점수들도 함께 사라집니다.\n그래도 진행하시겠습니까?';
}
