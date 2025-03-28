import 'package:get/get.dart';

import 'package:jlpt_jonggack/features/grammar_test/grammar_test_screen.dart';
import 'package:jlpt_jonggack/features/calendar_step/grammar_calendar_step_screen.dart';
import 'package:jlpt_jonggack/features/jlpt_test/screens/jlpt_test_screen.dart';
import 'package:jlpt_jonggack/features/kangi_test/kangi_test_screen.dart';
import 'package:jlpt_jonggack/features/my_voca/screens/my_voca_sceen.dart';
import 'package:jlpt_jonggack/features/score/screens/kangi_score_screen.dart';
import 'package:jlpt_jonggack/features/score/screens/score_screen.dart';
import 'package:jlpt_jonggack/features/setting/screens/setting_screen.dart';

import 'features/home/screens/home_screen.dart';

class AppRoutes {
  static List<GetPage<dynamic>> getPages = [
    GetPage(name: GRAMMAR_TEST_SCREEN, page: () => GrammarTestScreen()),
    GetPage(
      name: HOME_PATH,
      page: () => const HomeScreen(),
      // page: () => NewHomeScreen(),
    ),
    GetPage(name: KANGI_SCORE_PATH, page: () => const KangiScoreScreen()),
    GetPage(name: MY_VOCA_PATH, page: () => MyVocaPage()),
    GetPage(
      name: JLPT_CALENDAR_STEP_PATH,
      page: () => GrammarCalendarStepScreen(),
    ),
    GetPage(name: JLPT_TEST_PATH, page: () => const JlptTestScreen()),
    GetPage(name: KANGI_TEST_PATH, page: () => const KangiTestScreen()),
    GetPage(name: SCORE_PATH, page: () => const ScoreScreen()),
    GetPage(name: SETTING_PATH, page: () => const SettingScreen()),
  ];
}
