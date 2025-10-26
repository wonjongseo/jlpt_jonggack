import 'dart:async';
import 'package:jlpt_jonggack/common/admob/interstitial_manager.dart';
import 'package:jlpt_jonggack/common/app_constant.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/core/bindings/initial_bindings.dart';

import 'package:jlpt_jonggack/features/home/screens/home_screen.dart';
import 'package:jlpt_jonggack/features/setting/screen/setting_screen.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/features/search/controller/search_controller.dart';
import 'package:jlpt_jonggack/features/setting/services/setting_repository.dart';
import 'package:jlpt_jonggack/model/book.dart';
import 'package:jlpt_jonggack/repository/hive_repository.dart';
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
import 'package:jlpt_jonggack/repository/grammar_step_repository.dart';
import 'package:jlpt_jonggack/repository/jlpt_step_repository.dart';
import 'package:jlpt_jonggack/repository/kangis_step_repository.dart';
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
    final controller = Get.put(SettingController(), permanent: true);
    final Locale locale =
        controller.systemLocale ?? Get.deviceLocale ?? const Locale('ko', 'KR');

    return FutureBuilder(
      future: loadData(locale.languageCode),
      builder: (context, snapshat) {
        if (snapshat.hasData == true) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: HomeScreen.name,
            getPages: AppRoutes.getPages,
            fallbackLocale: const Locale('ko', 'KR'),
            initialBinding: InitialBindings(),
            theme: AppThemings.lightTheme,
            locale: locale,
            translations: AppString(),

            // themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          );
        } else if (snapshat.hasError) {
          return errorMaterialApp(snapshat);
        } else {
          return loadingMaterialApp(context);
        }
      },
    );
  }

  void getUsresSetting() {
    systemLanguage =
        SettingRepository.getString(AppConstant.settingLanguageKey) ?? "ko-KR";
    print('systemLanguage : ${systemLanguage}');

    isDarkMode =
        SettingRepository.getBool(AppConstant.isDarkModeKey) ??
        ThemeMode.system == ThemeMode.dark;
  }

  Future<bool> loadData(String systemLanguage) async {
    List<int> jlptWordScroes = [];
    List<int> grammarScores = [];
    List<int> kangiScores = [];
    try {
      // getUsresSetting();

      jlptWordScroes = await WordLoadService.wordDataLoad(systemLanguage);
      kangiScores = await WordLoadService.kangiDataLoad(systemLanguage);
      grammarScores = await WordLoadService.grammarDataLoad(systemLanguage);

      late User user;
      if (await UserRepository.isExistData() == false) {
        List<int> currentJlptWordScroes = List.generate(
          jlptWordScroes.length,
          (index) => 0,
        );
        List<int> currentGrammarScores = List.generate(
          grammarScores.length,
          (index) => 0,
        );
        List<int> currentKangiScores = List.generate(
          kangiScores.length,
          (index) => 0,
        );

        user = User(
          jlptWordScroes: jlptWordScroes,
          grammarScores: grammarScores,
          kangiScores: kangiScores,
          currentJlptWordScroes: currentJlptWordScroes,
          currentGrammarScores: currentGrammarScores,
          currentKangiScores: currentKangiScores,
        );

        user = await UserRepository.init(user);
        if (!LocalReposotiry.isAskUpdateAllDataFor2_3_3()) {
          LocalReposotiry.putIsNeedUpdateAllData(false);
          LocalReposotiry.askedUpdateAllDataFor2_3_3(true);
        }
      } else {
        if (!LocalReposotiry.isAskUpdateAllDataFor2_3_3()) {
          LocalReposotiry.putIsNeedUpdateAllData(true);
          LocalReposotiry.askedUpdateAllDataFor2_3_3(true);
        }
      }

      UserController userController = Get.put(UserController());

      if (userController.user!.grammarScores.length == 3) {
        userController.addN4N5GrammarScore();
      }
      bool isPlus = await AppInfoService.isPlus();

      if (!isPlus) {
        userController.user!.isPremieum = false;
        UserRepository.updateUser(userController.user!);
      }

      bool isForceUpdate = await _isForceUpdate();
      if (isForceUpdate) {
        for (int i = 1; i < 6; i++) {
          jlptWordScroes[i - 1] = await JlptStepRepositroy.updateJlptStepData(
            systemLanguage,
            "$i",
          );
        }
        for (int i = 1; i < 7; i++) {
          kangiScores[i - 1] = await KangiStepRepositroy.updateKangiStepData(
            systemLanguage,
            "$i",
          );
        }
        for (int i = 1; i < 6; i++) {
          grammarScores[i - 1] = await GrammarRepositroy.updateGrammarStepData(
            systemLanguage,
            "$i",
          );
        }
      }

      final bookRepo = Get.find<HiveRepository<Book>>();

      if (bookRepo.getAll().isEmpty) {
        await LocalReposotiry.migrationToBook(userController.user!);
      }

      Get.put(JSearchController());
    } catch (e) {
      rethrow;
    }
    return true;
  }

  Future<bool> _isForceUpdate() async {
    return await LocalReposotiry.checkAndExecuteFunction();
  }

  MaterialApp loadingMaterialApp(BuildContext context) {
    print('isKo : ${isKo}');
    print('isEn : ${isEn}');

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

  MaterialApp errorMaterialApp(AsyncSnapshot<bool> snapshat) {
    String errorMsg = snapshat.error.toString();
    if (errorMsg.contains('Connection refused')) {
      errorMsg = '서버와 연결이 불안정 합니다. 데이터 연결 혹은 Wifi환경에서 다시 요청해주시기 바랍니다.';
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'JLPT종각 앱 이용 하기 앞서,',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Text(
                    '데이터를 저장하기 위해 1회 서버와 연결을 해야합니다.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '데이터 연결 혹은 와이파이 환경에서 다시 요청해주시기 바랍니다.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(errorMsg)],
          ),
        ),
      ),
    );
  }
}
