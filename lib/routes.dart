import 'package:get/get.dart';

import 'package:jlpt_jonggack/features/grammar_test/grammar_test_screen.dart';
import 'package:jlpt_jonggack/features/calendar_step/grammar_calendar_step_screen.dart';
import 'package:jlpt_jonggack/features/jlpt_test/controller/jlpt_test_controller.dart';
import 'package:jlpt_jonggack/features/quiz/screen/jlpt_test_screen.dart';
import 'package:jlpt_jonggack/features/quiz/screen/kangi_test_screen.dart';
import 'package:jlpt_jonggack/features/my_book/screens/widgets/edit_book_screen.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/new_add_my_word_screen.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/new_my_word_screen.dart';
import 'package:jlpt_jonggack/features/setting/screen/setting_screen.dart';

import 'package:jlpt_jonggack/features/score/screens/kangi_score_screen.dart';
import 'package:jlpt_jonggack/features/score/screens/score_screen.dart';

import 'features/home/screens/home_screen.dart';

class AppRoutes {
  static List<GetPage<dynamic>> getPages = [
    GetPage(name: GrammarTestScreen.name, page: () => GrammarTestScreen()),
    GetPage(
      name: HomeScreen.name,
      page: () => const HomeScreen(),
      // page: () => NewHomeScreen(),
    ),
    GetPage(name: KANGI_SCORE_PATH, page: () => const KangiScoreScreen()),

    GetPage(name: EditBookScreen.name, page: () => EditBookScreen()),
    GetPage(name: NewMyWordScreen.name, page: () => NewMyWordScreen()),
    GetPage(name: NewAddMyWordScreen.name, page: () => NewAddMyWordScreen()),
    GetPage(
      name: GrammarCalendarStepScreen.name,
      page: () => GrammarCalendarStepScreen(),
    ),
    GetPage(
      name: JlptTestScreen.name,
      page: () => const JlptTestScreen(),
      binding: BindingsBuilder.put(() {
        final controller = JlptTestController();
        controller.init(Get.arguments);
        return controller;
      }),
    ),
    GetPage(name: KangiTestScreen.name, page: () => const KangiTestScreen()),
    GetPage(name: SettingScreen.name, page: () => const SettingScreen()),
    GetPage(name: ScoreScreen.name, page: () => const ScoreScreen()),
  ];
}
