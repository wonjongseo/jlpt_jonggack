import 'dart:io';
import 'dart:ui';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/app_constant.dart';
import 'package:jlpt_jonggack/common/widget/custom_snack_bar.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/core/app_string.dart';

import 'package:jlpt_jonggack/features/setting/services/setting_repository.dart';
import 'package:jlpt_jonggack/repository/grammar_step_repository.dart';
import 'package:jlpt_jonggack/repository/jlpt_step_repository.dart';
import 'package:jlpt_jonggack/repository/kangis_step_repository.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';

bool get isKo => (Get.locale ?? Get.deviceLocale)?.languageCode == 'ko';
bool get isEn => (Get.locale ?? Get.deviceLocale)?.languageCode == 'en';

class SettingController extends GetxController {
  static SettingController get to => Get.find<SettingController>();
  final _systemLocale = Rxn<Locale>();
  Locale? get systemLocale => _systemLocale.value;

  final _isSubjective = true.obs;
  bool get isSubjective => _isSubjective.value;

  void toggleSubjective() {
    _isSubjective.value = !_isSubjective.value;
    SettingRepository.setBool(HVKey.settingModelBox, _isSubjective.value);
  }

  // Tts
  final speechRate = 0.5.obs;
  final volumn = 1.0.obs;
  final pitch = 1.0.obs;

  void getSystemLanguage() {
    final device = PlatformDispatcher.instance.locale;
    final saved = SettingRepository.getString(AppConstant.settingLanguageKey);

    if (saved == null) {
      _systemLocale.value = device;
    } else {
      _systemLocale.value =
          (saved == 'ko') ? const Locale('ko', 'KR') : const Locale('en', 'US');
    }
  }

  void getTtsValue() {
    speechRate.value =
        SettingRepository.getDouble(AppConstant.speechRateKey) ?? 0.5;
    volumn.value = SettingRepository.getDouble(AppConstant.volumnKey) ?? 1.0;
    pitch.value = SettingRepository.getDouble(AppConstant.pitchKey) ?? 1.0;
  }

  double tTsValue(SoundOptions command) {
    switch (command) {
      case SoundOptions.speedRate:
        return speechRate.value;
      case SoundOptions.volumn:
        return volumn.value;
      case SoundOptions.pitch:
        return pitch.value;
    }
  }

  void updateSoundValues(SoundOptions command, double newValue, bool isEnd) {
    if (newValue >= 1 && newValue <= 0) return;

    switch (command) {
      case SoundOptions.speedRate:
        if (isEnd) {
          SettingRepository.setDouble(AppConstant.speechRateKey, newValue);
        }
        speechRate.value = newValue;
        break;
      case SoundOptions.volumn:
        if (isEnd) {
          SettingRepository.setDouble(AppConstant.volumnKey, newValue);
        }
        volumn.value = newValue;
        break;
      case SoundOptions.pitch:
        if (isEnd) {
          SettingRepository.setDouble(AppConstant.pitchKey, newValue);
        }
        pitch.value = newValue;
        break;
    }
    update();
  }

  final incorrectDuration = 1500.obs;
  final correctDuration = 1000.obs;

  void getQuizValue() {
    incorrectDuration.value =
        SettingRepository.getInt(AppConstant.incorrectDurationKey) ?? 1500;
    correctDuration.value =
        SettingRepository.getInt(AppConstant.correctDurationKey) ?? 1000;
  }

  int quizValue(QuizDuration command) {
    switch (command) {
      case QuizDuration.incorrect:
        return incorrectDuration.value;
      case QuizDuration.correct:
        return correctDuration.value;
    }
  }

  void updateQuizDuration(QuizDuration command, bool isIncrease) {
    int value = kReleaseMode ? 500 : 100;
    switch (command) {
      case QuizDuration.incorrect:
        int newValue =
            isIncrease
                ? incorrectDuration.value + value
                : incorrectDuration.value - value;

        if (newValue > 10000 || newValue <= 0) return;
        incorrectDuration.value = newValue;
        SettingRepository.setInt(AppConstant.incorrectDurationKey, newValue);
        break;

      case QuizDuration.correct:
        int newValue =
            isIncrease
                ? correctDuration.value + value
                : correctDuration.value - value;

        if (newValue > 10000 || newValue <= 0) return;

        correctDuration.value = newValue;
        SettingRepository.setInt(AppConstant.correctDurationKey, newValue);
        break;
    }
  }

  @override
  void onInit() {
    getSystemLanguage();
    getTtsValue();
    getQuizValue();
    super.onInit();
  }

  void changeSystemLanguage(String? displayLanguage) async {
    // if (displayLanguage == null) return;
    // if (isKo && displayLanguage == 'ko') return;
    // if (isEn && displayLanguage == 'en') return;

    final result = await Get.dialog(
      AlertDialog.adaptive(
        title: Text(AppString.doChangeLanaguge.tr),
        content: Text(AppString.doChangeLanaguge2.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(AppString.no.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(AppString.yes.tr),
          ),
        ],
      ),
    );
    if (result == true) {
      if (displayLanguage == 'ko') {
        await SettingRepository.setString(AppConstant.settingLanguageKey, 'ko');
        Get.updateLocale(const Locale('ko', 'KR'));
      } else if (displayLanguage == 'en') {
        await SettingRepository.setString(AppConstant.settingLanguageKey, 'en');
        Get.updateLocale(const Locale('en', 'US'));
      }

      GrammarRepositroy.deleteAllGrammar();
      JlptStepRepositroy.deleteAllWord();
      KangiStepRepositroy.deleteAllKangiStep();
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  void allDataDelete() {
    UserController.to.initializeProgress(TotalProgressType.JLPT);
    JlptStepRepositroy.deleteAllWord();
    UserController.to.initializeProgress(TotalProgressType.KANGI);
    KangiStepRepositroy.deleteAllKangiStep();
    UserController.to.initializeProgress(TotalProgressType.GRAMMAR);
    GrammarRepositroy.deleteAllGrammar();
    successDeleteAndQuitApp();
  }

  Future<void> successDeleteAndQuitApp() async {
    Get.closeAllSnackbars();
    showSnackBar(
      '초기화 완료, 재실행 해주세요!\n3초 뒤 자동적으로 앱이 종료됩니다.',
      duration: const Duration(seconds: 4),
    );
    await Future.delayed(const Duration(seconds: 4), () {
      if (kReleaseMode) {
        exit(0);
      }
    });
  }
}
