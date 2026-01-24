import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/app_constant.dart';
import 'package:jlpt_jonggack/common/utils/snackbar_helper.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart' as FB;
import 'package:jlpt_jonggack/features/setting/services/setting_repository.dart';
import 'package:jlpt_jonggack/model/book.dart';
import 'package:jlpt_jonggack/model/book_catgory.dart';
import 'package:jlpt_jonggack/repository/grammar_step_repository.dart';
import 'package:jlpt_jonggack/repository/hive_repository.dart';
import 'package:jlpt_jonggack/repository/jlpt_step_repository.dart';
import 'package:jlpt_jonggack/repository/kangis_step_repository.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';
import 'package:jlpt_jonggack/user/repository/user_repository.dart';

String normalizeLang(Locale? l) {
  final code = l?.languageCode ?? 'en';
  return (code == 'ko' || code == 'en') ? code : 'en';
}

Locale? _preferredLocale() {
  try {
    if (Get.isRegistered<SettingController>()) {
      final c = Get.find<SettingController>();
      if (c.systemLocale != null) return c.systemLocale;
    }
  } catch (_) {}
  return Get.locale ?? Get.deviceLocale ?? const Locale('en', 'US');
}

String get _effectiveLang => normalizeLang(_preferredLocale());

bool get isKo => _effectiveLang == 'ko';
bool get isEn => _effectiveLang == 'en';

class SettingController extends GetxController {
  static SettingController get to => Get.find<SettingController>();
  final _systemLocale = Rxn<Locale>();
  Locale? get systemLocale => _systemLocale.value;

  final _isSubjective = true.obs;
  bool get isSubjective => _isSubjective.value;

  final isAlertGranted = false.obs;

  void setIsAlertGranted({bool? value}) {
    if (value == null) {
      isAlertGranted.value = !isAlertGranted.value;
    } else {
      isAlertGranted.value = value;
    }

    SettingRepository.setBool(
      AppConstant.isAlertGrantedKey,
      isAlertGranted.value,
    );
  }

  void getIsSubjective() {
    _isSubjective.value =
        SettingRepository.getBool(HVKey.settingModelBox) ?? true;
  }

  void toggleSubjective() {
    _isSubjective.value = !_isSubjective.value;
    SettingRepository.setBool(HVKey.settingModelBox, _isSubjective.value);
  }

  // Tts
  final speechRate = 0.5.obs;
  final volumn = 1.0.obs;
  final pitch = 1.0.obs;

  Locale _toSupportedLocale(Locale? l) {
    final code = normalizeLang(l);
    return (code == 'ko') ? const Locale('ko', 'KR') : const Locale('en', 'US');
  }

  void setSystemLanguage(Locale locale) {
    SettingRepository.setString(
      AppConstant.settingLanguageKey,
      locale.languageCode,
    );
  }

  Future<void> getSystemLanguage() async {
    final saved = SettingRepository.getString(AppConstant.settingLanguageKey);

    bool isLegacyUser = UserController.to.user != null;

    if (saved == null || saved.isEmpty || saved == 'system') {
      final Locale decided =
          isLegacyUser
              ? const Locale('ko', 'KR')
              : _toSupportedLocale(PlatformDispatcher.instance.locale);

      _systemLocale.value = decided;
      await SettingRepository.setString(
        AppConstant.settingLanguageKey,
        decided.languageCode,
      );
      return;
    }

    final savedLangCode = saved.split(RegExp(r'[-_]')).first.toLowerCase();

    _systemLocale.value =
        (savedLangCode == 'ko')
            ? const Locale('ko', 'KR')
            : const Locale('en', 'US'); // ko 외엔 전부 en
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
  void onInit() async {
    await getSystemLanguage();
    await getIsDarkMode();
    getSaveWordNoti();
    getIsSubjective();
    getTtsValue();
    getQuizValue();
    super.onInit();
  }

  final isDeletingFinish = false.obs;

  void changeSystemLanguage(String? changedSystemLang) async {
    if (changedSystemLang == null) return;
    if (isKo && changedSystemLang == 'ko') return;
    if (isEn && changedSystemLang == 'en') return;

    isDeletingFinish.value = false;

    bool? result = await Get.dialog(
      name: "changeSystemLanguage",
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
      Get.dialog(
        AlertDialog.adaptive(
          title: Obx(
            () =>
                isDeletingFinish.value
                    ? Text(AppString.doneInital.tr)
                    : Text(
                      AppString.plzDontCloseApp.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
          ),
          content: Obx(
            () =>
                isDeletingFinish.value
                    ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          AppString.plzReStart.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    )
                    : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10),
                        CircularProgressIndicator.adaptive(),
                        SizedBox(height: 10),

                        Text(AppString.initalStart.tr),
                      ],
                    ),
          ),
        ),
      );

      await SettingRepository.setBool(AppConstant.isUpdated, true);

      if (changedSystemLang == 'ko') {
        // _systemLocale.value = Locale('ko', 'KR');
        await SettingRepository.setString(AppConstant.settingLanguageKey, 'ko');
      } else if (changedSystemLang == 'en') {
        // _systemLocale.value = Locale('en', 'US');
        await SettingRepository.setString(AppConstant.settingLanguageKey, 'en');
      }
      bool isEn = changedSystemLang == 'en';
      allDataDelete(isEn);
    }
  }

  void allDataDelete(bool isEn, {bool isUserDelete = true}) async {
    try {
      await _changeMy12Book(isEn);

      await LocalReposotiry.deleteProgress();
      await JlptStepRepositroy.deleteAllWord();
      await KangiStepRepositroy.deleteAllKangiStep();
      await GrammarRepositroy.deleteAllGrammar();

      if (isUserDelete) {
        await UserRepository.deleteUser();
      }

      isDeletingFinish.value = true;

      await Future.delayed(const Duration(milliseconds: 1500), () {
        if (kReleaseMode) {
          exit(0);
        } else {
          Get.back();
        }
      });
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('$e');
    }
  }

  Future<void> _changeMy12Book(bool isEn) async {
    final repo = Get.find<HiveRepository<Book>>();
    final books = repo.getAll();

    final jgBook = books.firstWhere((b) => b.bookNum == Book.jgBookNum);
    final myBook = books.firstWhereOrNull((b) => b.bookNum == 2);

    final jgTitle = isEn ? AppString.jgVocaEn : AppString.jgVocaKr;
    final jgDesc = isEn ? AppString.jgVocaDescEn : AppString.jgVocaDescKr;

    final myTitleDefaultKo = AppString.myVocaKr;
    final myTitleDefaultEn = AppString.myVocaEn;
    final myDescDefaultKo = AppString.myVocaDescKr;
    final myDescDefaultEn = AppString.myVocaDescEn;

    final toSave = <String, Book>{};

    final updated = jgBook.copyWith(title: jgTitle, description: jgDesc);
    if (updated != jgBook) {
      toSave[jgBook.id] = updated;
    }

    if (myBook != null) {
      Book updated = myBook;

      if (isEn) {
        if (myBook.title == myTitleDefaultKo) {
          updated = updated.copyWith(title: myTitleDefaultEn);
        }
        if (myBook.description == myDescDefaultKo) {
          updated = updated.copyWith(description: myDescDefaultEn);
        }
      } else {
        if (myBook.title == myTitleDefaultEn) {
          updated = updated.copyWith(title: myTitleDefaultKo);
        }
        if (myBook.description == myDescDefaultEn) {
          updated = updated.copyWith(description: myDescDefaultKo);
        }
      }

      if (updated != myBook) {
        toSave[myBook.id] = updated;
      }
    }

    if (toSave.isNotEmpty) {
      for (final entry in toSave.entries) {
        await repo.put(entry.key, entry.value);
      }
    }

    for (var book in books) {
      final updatedCats = List<BookCategory>.from(book.categories ?? []);
      final unspecified = updatedCats.first;

      updatedCats[0] = unspecified.copyWith(
        name: isEn ? AppString.unspecifiedEn : AppString.unspecifiedKr,
      );

      book = book.copyWith(categories: updatedCats);

      await repo.put(book.id, book);
    }
  }

  final Rx<bool> _saveWordNoti = true.obs;
  bool get saveWordNoti => _saveWordNoti.value;

  void getSaveWordNoti() {
    _saveWordNoti.value =
        SettingRepository.getBool(AppConstant.saveWordNoti) ?? true;
  }

  void toggleSaveWordNoti(bool v) {
    _saveWordNoti.value = v;
    SettingRepository.setBool(AppConstant.saveWordNoti, _saveWordNoti.value);
  }

  final Rx<bool> _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  Future<void> toggleDarkMode(v) async {
    _isDarkMode.value = v;
    ThemeMode themeMode = _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(themeMode);

    await SettingRepository.setBool(AppConstant.isDarkMode, _isDarkMode.value);
  }

  Future<void> getIsDarkMode() async {
    final isDarkMode = SettingRepository.getBool(AppConstant.isDarkMode);
    if (isDarkMode == null) {
      final brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      final deviceIsDark = brightness == Brightness.dark;
      await toggleDarkMode(deviceIsDark);
    }
    _isDarkMode.value = SettingRepository.getBool(AppConstant.isDarkMode)!;
  }

  Color get realBlackOrWhite =>
      _isDarkMode.value ? AppColors.whiteGrey : Colors.black;

  Color get mainColor =>
      _isDarkMode.value ? AppColors.darkMainColor : AppColors.mainColor;

  Color get mainBordColor =>
      _isDarkMode.value ? AppColors.darkMainBordColor : AppColors.mainBordColor;

  Color get blackOrWhite =>
      _isDarkMode.value ? AppColors.scaffoldBackground : Colors.white;

  Color get nonSelectedColor =>
      _isDarkMode.value
          ? Colors.white.withOpacity(.8)
          : AppColors.scaffoldBackground.withOpacity(0.5);
}
