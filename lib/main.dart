import 'dart:async';
import 'package:jlpt_jonggack/common/admob/interstitial_manager.dart';
import 'package:jlpt_jonggack/common/app_constant.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/core/bindings/initial_bindings.dart';

import 'package:jlpt_jonggack/features/home/screens/home_screen.dart';
import 'package:jlpt_jonggack/features/search/controller/search_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/features/setting/services/setting_repository.dart';
import 'package:jlpt_jonggack/model/book.dart';
import 'package:jlpt_jonggack/repository/grammar_step_repository.dart';
import 'package:jlpt_jonggack/repository/hive_repository.dart';
import 'package:jlpt_jonggack/repository/jlpt_step_repository.dart';
import 'package:jlpt_jonggack/repository/kangis_step_repository.dart';
import 'package:jlpt_jonggack/routes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jlpt_jonggack/services/app_info_service.dart';
import 'package:jlpt_jonggack/services/word_load_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/model/user.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';
import 'package:jlpt_jonggack/user/repository/user_repository.dart';

/*
 유료버전과 무료버전 업로드 시 .

STEP 1. 프로젝트 명 반드시 바꾸기!!
JLPT 종각
  JLPT 종각 => flutter pub run change_app_package_name:main com.wonjongseo.jlpt_jonggack
  JLPT 종각 Plus => flutter pub run change_app_package_name:main com.wonjongseo.jlpt_jonggack_plus

IOS번들은 
com.wonjongseo.jlpt-jonggack
com.wonjongseo.jlpt-jonggack-plus


STEP 2. 앱 이름 바꾸기 
  JLPT 종각 <-> JLPT 종각 Plus

STEP 2-1. 번들 이름 바꾸기 

  iOS Path- ios/Runner/Info.plist
  Android Path- android/app/src/main/AndroidManifest.xml

  japanese_voca <-> japanese_voca_plus
  

STEP 3.
  앱 아이콘 바꾸기

STEP 4.  
  User isPremieum = false <-> true

STEP 5. 
  버전 바꾸기

STEP 6.
안드로이드 이름 바꾸기
 JLPT 종각 <-> JLPT 종각 Plus
 JLPT Jg <-> JLPT Jg Plus
  

Android Command - flutter build appbundle
Hive - flutter pub run build_runner build --delete-conflicting-outputs


 */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  InterstitialManager.instance.configure(
    maxPerDay: 1000,
    showChance: 1,
    cooldownMinutes: 10,
  );

  InterstitialManager.instance.preload();

  initializeDateFormatting();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

  await LocalReposotiry.init();

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeMode themeMode = ThemeMode.system;
  late bool isDarkMode;
  late String systemLanguage;
  @override
  Widget build(BuildContext context) {
    Get.put(UserController());

    final controller = Get.put(SettingController(), permanent: true);
    if (controller.systemLocale == null) {
      return loadingMaterialApp(context);
    }

    final effectiveLocale = controller.systemLocale!;
    final langCode = normalizeLang(effectiveLocale);

    return FutureBuilder(
      future: loadData(langCode),
      builder: (context, snapshat) {
        if (snapshat.hasData == true) {
          return GetMaterialApp(
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              return MediaQuery(
                data: mediaQuery.copyWith(textScaleFactor: 0.85),
                child: child!,
              );
            },
            debugShowCheckedModeBanner: false,
            initialRoute: HomeScreen.name,
            getPages: AppRoutes.getPages,
            fallbackLocale: const Locale('en', 'US'),
            initialBinding: InitialBindings(),
            theme: AppThemings.lightTheme2,
            darkTheme: AppThemings.darkTheme,
            themeMode: controller.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            locale: effectiveLocale,
            translations: AppString(),
          );
        } else {
          return loadingMaterialApp(context);
        }
      },
    );
  }

  Future<bool> loadData(String langCode) async {
    try {
      bool isUploaded = false;
      bool isPlus = await AppInfoService.isPlus();
      final isUpdated =
          SettingRepository.getBool(AppConstant.isUpdated) ?? false;

      final isUser = UserController.to.user != null;

      if (!isUser || isUpdated) {
        if (isUpdated) {
          await LocalReposotiry.deleteProgress();
          await JlptStepRepositroy.deleteAllWord();
          await KangiStepRepositroy.deleteAllKangiStep();
          await GrammarRepositroy.deleteAllGrammar();
          await SettingRepository.setBool(AppConstant.isUpdated, false);
        }
        isUploaded = true;

        final results = await Future.wait([
          WordLoadService.wordDataLoad(langCode),
          WordLoadService.kangiDataLoad(langCode),
          WordLoadService.grammarDataLoad(langCode),
        ]);
        final wordCnt = results[0];
        final kangiCnt = results[1];
        final grammarCnt = results[2];

        final user = User(
          jlptWordScroes: wordCnt,
          grammarScores: grammarCnt,
          kangiScores: kangiCnt,
          currentJlptWordScroes: List.filled(wordCnt.length, 0),
          currentGrammarScores: List.filled(grammarCnt.length, 0),
          currentKangiScores: List.filled(kangiCnt.length, 0),
        )..isPremieum = isPlus;

        UserController.to.user = await UserRepository.init(user);

        await SettingRepository.setString(
          'createAt',
          DateTime.now().toIso8601String(),
        );
      } else {
        // 설정 잘못했을 경우.
        if (UserController.to.user!.isPremieum != isPlus) {
          UserController.to.user!.isPremieum = isPlus;
          await UserRepository.updateUser(UserController.to.user!);
        }
        await _isForceUpdate(isUploaded);
      }

      final bookRepo = Get.find<HiveRepository<Book>>();

      if (bookRepo.getAll().isEmpty) {
        await LocalReposotiry.migrationToBook(UserController.to.user!);
      }

      Get.put(JSearchController());
    } catch (e) {
      rethrow;
    }
    return true;
  }

  Future<void> _isForceUpdate(bool isNew) async {
    if (isNew) return;

    final isForce = await LocalReposotiry.checkAndExecuteFunction();
    if (isForce) {
      String systemLang = SettingController.to.systemLocale!.languageCode;
      List<int> jlptWordScroes = await WordLoadService.updateWordData(
        systemLang,
      );

      List<int> kangiScores = await WordLoadService.updateKangisData(
        systemLang,
      );

      List<int> grammarScores = await WordLoadService.updateGrammarData(
        systemLang,
      );

      UserController.to.user = UserController.to.user!.copyWith(
        jlptWordScroes: jlptWordScroes,
        grammarScores: grammarScores,
        kangiScores: kangiScores,
      );
      await UserRepository.updateUser(UserController.to.user!);
    }
  }

  Locale resolveLocale(Locale? preferred, Locale? device) {
    final lang = normalizeLang(preferred ?? device);
    return lang == 'ko' ? Locale('ko', 'KR') : Locale('en', 'US');
  }

  MaterialApp loadingMaterialApp(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isKo ? '데이터를 불러오는 중입니다.' : "Loading Datas...",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TweenAnimationBuilder(
                curve: Curves.fastOutSlowIn,
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 25),
                builder: (context, value, child) {
                  return Column(
                    children: [
                      SizedBox(
                        width: 250,
                        child: LinearProgressIndicator(
                          backgroundColor: const Color(0xFF191923),
                          value: value,
                          color: const Color(0xFFFFC107),
                        ),
                      ),
                      const SizedBox(height: 16 / 2),
                      Text('${(value * 100).toInt()}%'),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// en [3035, 1727, 1692, 573, 657], grammarScores: [243, 195, 182, 130, 80], kangiScores: [951, 695, 184, 36, 81, 217]
// ko [3195, 2586, 1537, 1018, 741], grammarScores: [213, 174, 144, 49, 19], kangiScores: [951, 695, 184, 36, 81, 217]